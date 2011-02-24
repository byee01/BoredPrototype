module Paperclip
#  class Attachment
    def self.default_options
      @default_options ||= {
        :url           => "/system/:class/:attachment/:id/:style/:basename.:extension",
        :path          => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
        :styles        => {},
        :default_url   => "/system/:attachment/:style/missing.png",
        :default_style =>  :original,
        :validations   => [],
        :storage       => :filesystem
      }
  #  end
  end
end