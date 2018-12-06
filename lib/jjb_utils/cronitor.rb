module JJB_Utils::Cronitor
  def self.jjb(jjb_template, monitor_code, report_on_run, report_on_success)
    on_run_url      = "https://cronitor.link/#{monitor_code}/run"
    on_complete_url = "https://cronitor.link/#{monitor_code}/complete"

    run_builder      = { 'shell' => "curl -sf '#{on_run_url}'" }
    complete_builder = { 'shell' => "curl -sf '#{on_complete_url}'" }

    publisher = [{ 'conditional-publisher' => [{
      'condition-kind'  => 'current-status',
      'condition-best'  => 'SUCCESS',
      'condition-worst' => 'SUCCESS',
      'action' => [{
        'postbuildscript' => { 'builders' => [complete_builder] }
      }]
    }]}]

    JJB_Utils::JJB.validate(jjb_template)

    jjb_template = JJB_Utils::JJB.add_builder(
      jjb_template, run_builder
    ) if report_on_run

    jjb_template = JJB_Utils::JJB.add_publisher(
      jjb_template, publisher
    ) if report_on_success

    jjb_template
  end
end
