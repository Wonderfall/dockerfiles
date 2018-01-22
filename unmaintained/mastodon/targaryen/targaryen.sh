#!/bin/sh

### Increase number of characters / toot
sed -i -e 's/500/800/g' \
    app/javascript/mastodon/features/compose/components/compose_form.js \
    app/validators/status_length_validator.rb \
    storybook/stories/character_counter.story.js \
    config/locales/*.yml

### Increase bio length
sed -i -e 's/160/400/g' \
    app/javascript/packs/public.js \
    app/models/account.rb \
    app/views/settings/profiles/show.html.haml

### Dragon emoji
sed -i -e 's/1f602/1f432/g' \
    app/javascript/mastodon/features/compose/components/emoji_picker_dropdown.js
