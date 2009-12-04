LIFT_VERSION = "1.1-SNAPSHOT"
SLF4J_VERSION = "1.5.6"

repositories.remote = [ 
  "http://mirrors.ibiblio.org/pub/mirrors/maven2/",
  "http://scala-tools.org/repo-releases/",
  "http://ftp.cica.es/mirrors/maven2/"
]

ACTIVATION   = "javax.activation:activation:jar:1.1"

CODEC        = "commons-codec:commons-codec:jar:1.3"

COLLECTIONS  = "commons-collections:commons-collections:jar:3.2.1"

COMMONS_IO   = "commons-io:commons-io:jar:1.4"

COMMONS_LANG = "commons-lang:commons-lang:jar:2.4"

FILEUPLOAD   = "commons-fileupload:commons-fileupload:jar:1.2.1"

H2 = "com.h2database:h2:jar:1.1.105"

HTTPCLIENT  = "commons-httpclient:commons-httpclient:jar:3.1"

JAVAMAIL = "javax.mail:mail:jar:1.4"

LIFT = group("lift-webkit", "lift-common", "lift-util", "lift-actor",
       :under=>"net.liftweb", :version=> LIFT_VERSION)

LIFT_MAPPER = group("lift-mapper",
              :under=>"net.liftweb", :version=> LIFT_VERSION)

LOG4J = "log4j:log4j:jar:1.2.15"  

SCALA = "org.scala-lang:scala-library:jar:2.7.7"

SERVLET_API = "javax.servlet:servlet-api:jar:2.5"

SLF4J = [
  "org.slf4j:slf4j-api:jar:#{SLF4J_VERSION}",
  "org.slf4j:slf4j-log4j12:jar:#{SLF4J_VERSION}",
  "org.slf4j:jcl-over-slf4j:jar:#{SLF4J_VERSION}"
]

PARANAMER = "com.thoughtworks.paranamer:paranamer:jar:2.0"


# Testing dependencies

JETTY = [
  "org.mortbay.jetty:jetty:jar:6.1.12",
  "org.mortbay.jetty:jetty-util:jar:6.1.12",
  "regexp:regexp:jar:1.3"
]

JWEBUNIT = [ 
  "net.sourceforge.jwebunit:jwebunit-core:jar:2.2",
  "net.sourceforge.jwebunit:jwebunit-htmlunit-plugin:jar:2.2",
  "net.sourceforge.htmlunit:htmlunit:jar:2.5",
  "org.mockito:mockito-all:jar:1.7",
  "net.sourceforge.cssparser:cssparser:jar:0.9.5",
  "net.sourceforge.htmlunit:htmlunit-core-js:jar:2.5",
  "net.sourceforge.jwebunit:jwebunit-core:jar:2.2",
  "net.sourceforge.nekohtml:nekohtml:jar:1.9.12",
  "org.w3c.css:sac:jar:1.3"
]

JUNIT = "junit:junit:jar:4.5"

JUNIT_PERF = "junitperf:junitperf:jar:1.8"

