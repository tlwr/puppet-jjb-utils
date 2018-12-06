module Puppet::Parser::Functions
  newfunction(
    :cronitor_jjb,
    :arity => -3, # At least two arguments
    :type  => :rvalue,
    :doc   => <<EOS
Modifies a Jenkins Job Builder template

Parameters:

- jjb_template      (Jenkins Job Builder template)     (mandatory String)
- monitor_code      (the cronitor URL code)            (mandatory String)
- report_on_run     (to send a /run notification)      (opt Bool, default true)
- report_on_success (to send a /complete notification) (opt Bool, default true)

Returns the modified JJB template
EOS
  ) do |args|
    jjb_template      = args[0]
    monitor_code      = args[1]
    report_on_run     = args[2] == nil ? true : args[2]
    report_on_success = args[3] == nil ? true : args[3]

    JJB_Utils::Cronitor::jjb(
      jjb_template, monitor_code, report_on_run, report_on_success
    )
  end
end
