require 'jruby_cxf'
 
class Animal
  include CXF::ComplexType
 
  member :kind, :string
 
  namespace 'http://opensourcesoftwareandme.blogspot.com'
end  
 
class Person
  include CXF::ComplexType
 
  member :name, :string
  member :age, :int
  member :pet, :Animal, :required => false
 
  namespace 'http://opensourcesoftwareandme.blogspot.com'
 
end	
 
class HelloWorld
  include CXF::WebServiceServlet
 
  expose :say_hello, {:expects => [{:person => :Person}], :returns => :string}
  expose :give_age, {:expects => [{:person => :Person}], :returns => :string}
  
  service_name 'MyExample'
  service_namespace 'http://opensourcesoftwareandme.blogspot.com'
 
  def say_hello(person)
    return 'Hello ' + person.name
  end
 
  def give_age(person)
    return 'Your age is ' + person.age.to_s
  end
 
end

# Servlet path defaults to '/' if no argument is passed to the constructor
hello_world = HelloWorld.new('/hello-world')
 
server = org.eclipse.jetty.server.Server.new(8080)
contexts = org.eclipse.jetty.server.handler.ContextHandlerCollection.new
server.set_handler(contexts)
root_context = org.eclipse.jetty.servlet.ServletContextHandler.new(contexts, "/")
root_context.addServlet(org.eclipse.jetty.servlet.ServletHolder.new(hello_world), "/*")
server.start
