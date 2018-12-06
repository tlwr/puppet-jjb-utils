# puppet-jjb-utils

A puppet module for working with Jenkins Job Builder.

_Extremely_ alpha.

## Functionality

### `cronitor_jjb`

Is a function which wraps a JJB template and adds a builder and/or publisher
step(s) to interact with cronitor.

Parameters:

- `jjb_template`: A jjb template (YAML string)
- `monitor_code`: The cronitor code/token
- `report_on_run`: Bool, default true, whether to send a `/run` ping
- `report_on_success`: Bool, default true, whether to send a `/complete` ping
