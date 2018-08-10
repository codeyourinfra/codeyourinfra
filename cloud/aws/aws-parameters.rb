def get_defaults(key)
  { 'region' => 'sa-east-1',
    'group_id' => 'sg-03a29f2c2e99c9305',
    'subnet_id' => 'subnet-655c3902',
    'image_id' => 'ami-01316f8dfe32c01e2' }[key]
end

def get_from_env(env1, env2)
  ENV[env1] || ENV[env2]
end

def get_from_file(name, id)
  region = get_region()
  file = File.join(region, name) if Dir.exists?(region)
  json  = JSON.parse(File.read(file)) if File.file?(file)
  json[id] if !json.nil?
end

def get_region_from_env()
  get_from_env('AWS_REGION', 'EC2_REGION')
end

def get_region_from_file()
  aws_config_file = File.expand_path('~/.aws/config')
  if File.file?(aws_config_file)
    region_line = File.foreach(aws_config_file).detect { |line| line.start_with?('region') }
    region_line.split('=')[-1].strip if region_line
  end
end

def get_region()
  get_region_from_env() || get_region_from_file() || get_defaults('region')
end

def get_security_group_from_env()
  get_from_env('AWS_SECURITY_GROUP', 'EC2_SECURITY_GROUP')
end

def get_security_group_from_file()
  get_from_file('security-group.json', 'group_id')
end

def get_security_group()
  get_security_group_from_env() || get_security_group_from_file() || get_defaults('group_id')
end

def get_subnet_from_env()
  get_from_env('AWS_SUBNET', 'EC2_SUBNET')
end

def get_subnet_from_file()
    get_from_file('subnet.json', 'subnet_id')
end

def get_subnet()
  get_subnet_from_env() || get_subnet_from_file() || get_defaults('subnet_id')
end

def get_ami_from_env()
  get_from_env('AWS_AMI', 'EC2_AMI')
end

def get_ami_from_file()
  get_from_file('ubuntu-ami.json', 'image_id')
end

def get_ami()
  get_ami_from_env() || get_ami_from_file() || get_defaults('image_id')
end
