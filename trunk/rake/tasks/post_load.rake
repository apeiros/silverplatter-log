#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



# This rakefile doesn't define any tasks, it is run after Rakefile has run and before
# any other rakefile is imported, so it can clean up the Project object and resolve some
# dependencies.


# defaultize meta data
Project.meta.summary     ||= proc { extract_summary() }
Project.meta.description ||= proc { extract_description() || extract_summary() }


# defaultize rdoc task
if Project.rdoc then
	Project.rdoc.files   ||= []
	Project.rdoc.files    += FileList.new(Project.rdoc.include || %w[lib/**/* *.{txt markdown rdoc}])
	Project.rdoc.files    -= FileList.new(Project.rdoc.exclude) if Project.rdoc.exclude
	Project.rdoc.files.reject! { |f| File.directory?(f) }
	Project.rdoc.title   ||= "#{Project.meta.name}-#{Project.meta.version} Documentation"
	Project.rdoc.options ||= []
	Project.rdoc.options.push('-t', Project.rdoc.title)
end
