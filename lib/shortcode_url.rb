module ShortcodeUrl
  def self.included(base) 
    base.extend ShortcodeUrlMethod
  end

  module ShortcodeUrlMethod
    def shortcode_url(*args)
      fields = []
      options = {}
      
      args.each do |arg|
        if arg.is_a?(Hash)
          options.merge!(arg)
        else
          fields << arg
        end
      end
      fields = [:shortcode_url] if fields.empty?
      length = options[:length] || 4
      
      fields.each do |field|

        before_save "set_#{field}"

        class_eval do  
        
          define_method("set_#{field}") do                                     # def set_shortcode_url
            self.send("#{field}") || self.send("#{field}=", self.send("create_#{field}")) #   self.shortcode_url ||= create_shortcode_url
          end                                                                  # end
        
          define_method("create_#{field}") do
            begin
              unique_code = ([
                ("a".."z").to_a,
                ("A".."Z").to_a,
                ("0".."9").to_a,
                ['-', '_']].flatten
                  ).sort_by{rand}[0,length].join
            end until( unique_code.to_i.zero? and not unique_code == '0' * length and not self.class.send("find_by_#{field}", unique_code))
            return unique_code
          end
        end
      end
    end
  end
end

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, ShortcodeUrl)
end