require 'yaml'

module JJB_Utils::JJB
  def self.add_builder(template, builder)
    operate_on_yaml(template) do |jobs|
      builders = jobs[0]['job']['builders'] || []
      jobs[0]['job']['builders'] = [builder].concat(builders)
      jobs
    end
  end

  def self.add_publisher(template, publisher)
    operate_on_yaml(template) do |jobs|
      publishers = jobs[0]['job']['publishers'] || []
      jobs[0]['job']['publishers'] = publishers.concat([publisher])
      jobs
    end
  end

  def self.validate(template)
    operate_on_yaml(template) do |jobs|
      raise Exception.new('Jobs is not a list') unless jobs.class == Array
      raise Exception.new('There are no jobs')  if     jobs.empty?
    end
  end

  private

  def self.operate_on_yaml(template_str)
    YAML.dump(yield(YAML.load(template_str)))
  end
end
