require 'buildr/scala'
require 'dependencies'
require 'tasks/explode'

VERSION_NUMBER = "0.1-SNAPSHOT"

define "lift-template" do
  project.version = VERSION_NUMBER
  project.group = "org.example"

  compile.with LIFT, LIFT_MAPPER

  test.using :specs
  test.compile.with JETTY, SERVLET_API
  test.with COLLECTIONS

  package(:war).with :libs => [
    ACTIVATION, CODEC, COLLECTIONS, FILEUPLOAD, LIFT, LIFT_MAPPER, LOG4J, SCALA, SLF4J
  ]
  package(:war).explode :target => _("target/webapps/#{project.name}")
end

task "explode" => ["lift-template:explode"]


