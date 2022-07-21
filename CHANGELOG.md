## [0.1.1] - 2022-07-21

- Add `Halbuilder::Helper` module, automatically included in Rails views/controllers.
  Currently only has a `hal_zoomed?` method to help decide when to preload associations.
- `Jbuilder.ignore_nil(true)` by default

## [0.1.0] - 2022-07-20

Initial release, including:

- Key formatting options
- `json.hal_link!` href/block support
- `json.hal_embed!` lambda/block support
- `json.hal_paginate!` total/count/links
- `?zoom=` param parsing for embedded objects/collections
