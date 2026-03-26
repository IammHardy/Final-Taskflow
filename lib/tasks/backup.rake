namespace :db do
  namespace :backup do
    desc "Create database backup"
    task create: :environment do
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      backup_dir = Rails.root.join("tmp", "backups")
      FileUtils.mkdir_p(backup_dir)

      filename = "#{backup_dir}/taskflow_#{Rails.env}_#{timestamp}.dump"
      db_config = ActiveRecord::Base.connection_db_config.configuration_hash

      cmd = [
        "pg_dump",
        "--format=custom",
        "--no-acl",
        "--no-owner",
        "--host=#{db_config[:host] || 'localhost'}",
        "--username=#{db_config[:username]}",
        "--file=#{filename}",
        db_config[:database]
      ].join(" ")

      puts "Creating backup: #{filename}"
      system(cmd)
      puts "Done. Size: #{File.size(filename)} bytes"
    end

    desc "Restore database from backup"
    task :restore, [:file] => :environment do |_, args|
      abort "Usage: rake db:backup:restore[filename]" unless args[:file]
      abort "File not found" unless File.exist?(args[:file])

      db_config = ActiveRecord::Base.connection_db_config.configuration_hash

      cmd = [
        "pg_restore",
        "--no-acl",
        "--no-owner",
        "--host=#{db_config[:host] || 'localhost'}",
        "--username=#{db_config[:username]}",
        "--dbname=#{db_config[:database]}",
        args[:file]
      ].join(" ")

      puts "Restoring from #{args[:file]}..."
      system(cmd)
      puts "Done."
    end
  end
end