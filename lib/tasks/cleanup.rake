require 'rake/clean'

namespace :redmine do
  namespace :graphviz do
    desc 'Cleanup graphviz files'
    task cleanup: :environment do
      files = CLOBBER.include(File.join(Rails.root, 'files', 'graphviz_*.*'))
      FileUtils.rm(files)
    end
  end
end
