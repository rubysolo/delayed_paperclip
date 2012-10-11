require 'uri'
module DelayedPaperclip
  module UrlGenerator
    def self.included(base)
      base.send :include, InstanceMethods
      base.alias_method_chain :most_appropriate_url, :processed
    end

    def most_appropriate_url_with_processed
      if @attachment.original_filename.nil? || delayed_default_url?
        default_url
      else
         @attachment_options[:url]
      end
    end

    def delayed_default_url?
      !(@attachment.job_is_processing || @attachment.dirty? || !@attachment.delayed_options.try(:[], :url_with_processing) || !(@attachment.instance.respond_to?(:"#{@attachment.name}_processing?") && @attachment.processing?))
    end
  end

end