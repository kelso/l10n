module L10n
  module I18nExtensions
   
    def self.included(base)
      base.extend ClassMethods
    end
   
    module ClassMethods
     
      def default?
        language_code == default_language_code
      end
     
      def language_code
        normalize_language_code(locale) if locale
      end
      
      def country_code
        if locale.to_s.match(/\w\w-\w\w/)
          locale.to_s[-2..-1]
        else
          normalize_locale_code(locale)[-2..-1]
        end
      end
     
      def default_language_code
        normalize_language_code(default_locale) if default_locale
      end
     
      def available_language_codes
        available_locales.map { |locale| normalize_language_code(locale) }.uniq
      end

      def supported_language_codes
        [:en, :de]
      end
    
      def preferred_locale
        :de
      end
     
      def as(tmp_locale)
        if normalized_code = normalize_locale_code(tmp_locale)
          previous_locale = self.locale
          self.locale = normalized_code
        end
        yield
      ensure
        self.locale = previous_locale if normalized_code
      end
      
      def as_default
        I18n.as(I18n.default_locale) { yield }
      end
      
      def as_each
        supported_language_codes.inject({}) { |hash, code| hash[code] = I18n.as(code) { yield(code) }; hash }
      end
      
      def translations(key)
        supported_language_codes.inject({}) { |hash, code| hash[code] = I18n.as(code) { I18n.t(key) }; hash }
      end
      
      def translation_suffix
        default? ? '' : "_#{I18n.language_code}"
      end
     
      private
     
      def normalize_language_code(code)
        code.to_s[0..1].downcase.to_sym
      end
      
      def normalize_locale_code(code)
        normalize_language_code(code)
      end
      
    end
    
  end
end

I18n.extend L10n::I18nExtensions::ClassMethods