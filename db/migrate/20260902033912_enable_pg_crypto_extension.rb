class EnablePgCryptoExtension < ActiveRecord::Migration[8.1]
  def change
    def change
      enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    end
  end
end
