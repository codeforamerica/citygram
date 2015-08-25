namespace :docker do
  desc "Set up all containers needed for system operation"
  task :setup do
    system("docker create redis:3.0.3")
    system("docker create mdillon/postgis")
    system("docker build -t citygram .")
  end
end
