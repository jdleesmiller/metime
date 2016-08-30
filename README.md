# Metime

This is the source for the time tracker tool I wrote for my [How a Technical Co-founder Spends his Time: Minute-by-minute Data for a Year](http://jdlm.info/articles/2016/07/04/cto-time-minute-by-minute.html) blog post. It's not pretty, and it may even need some tweaks just to run on current versions of meteor, but since people have [asked for it on Hacker News](https://news.ycombinator.com/item?id=12385707), I have opened it up.

# Ramblings

Currently using a string with a special delimiter, ' - ', to mark the end of the 'tag section'.

This mostly works, but it has some oddities:

1. order is important -- 'dev render' is different from 'render dev', which is a bit odd for tags. It's nice for entry but not so good for analysis.

2. it's hard to run database queries on the 'tag section' as different from the 'note' section.

3. it's not so easy to explain

I'm also still not sure what kinds of queries we want to be able to do.

We're currently limited to one-word queries; this has some advantages:

1. colours are per-word, so it's fine to have multiple tagged words per entry

2. it's simple - queries = tags

The summary page is sort of like a 'dashboard' with lots of different queries on it. So it might be interesting to be able to watch a more complicated combination of tags on your dashboard, e.g. 'dev AND client1', or '(dev OR ops) AND client1', or '(biz OR admin) AND client1'.

If we did have a 'query' object, it could have a colour like a tag, but then it's not so easy to highlight the matching words in the text.

If we have both query and tag objects, then we can do both, but it means having more concepts.

An alternative to doing complicated queries / dashboards would be to make the dash interactive. Clicking on a tag could drill down to show the same table, grouped by tags that co-occur with the selected tag. Another point is that we may want 'just dev' as a row, and then a row for 'dev render', 'dev client1', etc.

Clicking on 'other' at top level should show you a list of other tags (not notes) that aren't in the top set of tags (if tags are defined implicitly). This should help weed out old / unused tags.

It would be nice to have a 'rename tag' feature; this would also serve to allow for merging.

How to display the 'notes'? Maybe if you click on a (tag, time period) point, you see a full list of unique entries with that tag in that period, with a total amount of time for each one, perhaps ordered by last occurrence.

What should tags be used for? I've been tagging github issue numbers, but is that really useful? It's hard to aggregate up from there. Tags could represent categories ('dev', 'ops', etc.), clients ('wl', 'metime'), characteristics ('email', 'meeting'), and probably other stuff.

If we have a select2 or similar in the tag entry field, and if we auto-colour tags, then we don't necessarily need to have a separate list of tags; they become more implicit.
[ tags ] [ details ] [ create ]
(We may want a way of letting people customise colours, but that's not very hard)

I'm starting to like the 'dashboards' / 'reports' idea --- they could be shareable as aggregate views.

# License

The MIT License (MIT)
Copyright (c) 2014-2016 John Lees-Miller

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
