require 'securerandom'

class User < ApplicationRecord
    validates(:first_name, :last_name, :email, :password, presence: true)
    validates(:email, uniqueness: true)
    attr_encrypted(:password, key: "\x1E\xE9j\x1DY\x96I\xC0\xD9]\xD3\x9F \x19\xBD`9\xD3\x82h\xA6\xFFWFP(\xAB&\xE6[%\xB5")
end
