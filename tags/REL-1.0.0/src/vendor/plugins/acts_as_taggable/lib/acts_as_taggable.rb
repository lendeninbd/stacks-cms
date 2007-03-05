module ActiveRecord
  module Acts #:nodoc:
    module Taggable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_taggable(options = {})
          write_inheritable_attribute(:acts_as_taggable_options, {
            :taggable_type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :from => options[:from]
          })
          
          class_inheritable_reader :acts_as_taggable_options

          has_many :taggings, :as => :taggable, :dependent => :destroy
          has_many :tags, :through => :taggings

          include ActiveRecord::Acts::Taggable::InstanceMethods
          extend ActiveRecord::Acts::Taggable::SingletonMethods          
        end
      end
      
      module SingletonMethods
        def find_tagged_with(list, options = {})   
          str  = "SELECT #{table_name}.* FROM #{table_name}, tags, taggings "
          str += "WHERE (#{table_name}.#{primary_key} = taggings.taggable_id "
          str += "AND taggings.taggable_type = ? "
          str += "AND taggings.tag_id = tags.id AND tags.name IN (?)) "
          str += "AND (#{sanitize_sql(options[:conditions])}) " unless options[:conditions].blank?
          str += "ORDER BY #{options[:order]}" unless options[:order].blank?
          
          query = [ str, acts_as_taggable_options[:taggable_type], list ]
          find_by_sql(query)
        end
      end
      
      module InstanceMethods
        def tag_with(list)
          Tag.transaction do
            taggings.destroy_all

            Tag.parse(list).each do |name|
              if acts_as_taggable_options[:from]
                send(acts_as_taggable_options[:from]).tags.find_or_create_by_name(name).on(self)
              else
                Tag.find_or_create_by_name(name).on(self)
              end
            end
          end
        end

        def tag_list
          tags.collect { |tag| tag.name.include?(" ") ? "'#{tag.name}'" : tag.name }.join(" ")
        end
      end
    end
  end
end