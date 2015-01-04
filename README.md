# Data Model

Currently using a string with a special delimiter, ' - ', to mark the end of the 'tag section'.

This mostly works, but it has some oddities:

1. order is important -- 'dev render' is different from 'render dev', which is a bit odd for tags. It's nice for entry but not so good for analysis.

2. it's hard to run database queries on the 'tag section' as different from the 'note' section.

3. it's not so easy to explain

I'm also still not sure what kinds of queries we want to be able to do.

We're currently limited to one-word queries; this has some advantages:

1. colours are per-word, so it's fine to have multiple tagged words per entry

2. it's simple - queries = tags

The summary page is sort of like a 'dashboard' with lots of different queries on it. So it might be interesting to be able to watch a more complicated combination of tags on your dashboard, e.g. 'dev AND newgen', or '(dev OR ops) AND newgen', or '(biz OR admin) AND newgen'.

If we did have a 'query' object, it could have a colour like a tag, but then it's not so easy to highlight the matching words in the text.

If we have both query and tag objects, then we can do both, but it means having more concepts.

An alternative to doing complicated queries / dashboards would be to make the dash interactive. Clicking on a tag could drill down to show the same table, grouped by tags that co-occur with the selected tag. Another point is that we may want 'just dev' as a row, and then a row for 'dev render', 'dev newgen', etc.

Clicking on 'other' at top level should show you a list of other tags (not notes) that aren't in the top set of tags (if tags are defined implicitly). This should help weed out old / unused tags.

It would be nice to have a 'rename tag' feature; this would also serve to allow for merging.

How to display the 'notes'? Maybe if you click on a (tag, time period) point, you see a full list of unique entries with that tag in that period, with a total amount of time for each one, perhaps ordered by last occurrence.

What should tags be used for? I've been tagging github issue numbers, but is that really useful? It's hard to aggregate up from there. Tags could represent categories ('dev', 'ops', etc.), clients ('wl', 'metime'), characteristics ('email', 'meeting'), and probably other stuff.

If we have a select2 or similar in the tag entry field, and if we auto-colour tags, then we don't necessarily need to have a separate list of tags; they become more implicit.
[ tags ] [ details ] [ create ]
(We may want a way of letting people customise colours, but that's not very hard)

I'm starting to like the 'dashboards' / 'reports' idea --- they could be shareable as aggregate views.
