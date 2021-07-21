# Zamingo

Candidate Test
In this project you are required to create an application that presents 2 tabs to the user.
The first tab should present the following information:
● Your name
● Date and Time (should be updated dynamically every time the label is presented to the user)
● An Empty label
The second tab should contain two segments:
● The first segment contains a table that will show the information received from Cars
● The second segment contains a table which is a unification of the data received from Sport and
Culture. First the rows from “Sports” should be presented, and then the rows from “Culture”
Feed URL base:
https://www.globes.co.il/webservice/rss/rssfeeder.asmx/FeederNode
Queries:
Cars: iID=3220
Sport: iID=2605
Culture: iID=3317
For example, this is the RSS for Cars:
https://www.globes.co.il/webservice/rss/rssfeeder.asmx/FeederNode?iID=3220
Requirements:
1. Selecting a feed (a table item) will push a new view with the description of the feed
2. The application should show in the empty label of the first tab, the text and description of the
title from the selected feed in the second tab
3. The application should check each RSS source (there are 3 RSS sources) every 5 seconds for an
update, and the application UI should be updated immediately as soon as one of the RSS sources
provides updated information.
Note: You need to take into account the fact that the different RSS’s might have different
response times.
4. Whenever the application checks for update, it should show a activity indicator (“Sivuvator”) in
the second tab
Instructions:
1. You should be able to explain what are the different building blocks of the application, and how
they communicate.
2. You should present a class diagram for the main classes of the application.
Good Luck!
Zemingo Team