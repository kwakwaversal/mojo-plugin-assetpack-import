use Mojolicious::Lite;

# This app demonstrates what happens if you pack CSS assets and do *NOT* put
# all CSS @import rules at the top
#
# https://developer.mozilla.org/en/docs/Web/CSS/@import

plugin AssetPack => {pipes => [qw(Css Combine)]};

# define asset that works (import is first)
app->asset->process(
  'import-is-first.css' => ('css/import-rule.css', 'css/body.css'));

# define asset that doen't work (import is packed second)
app->asset->process(
  'import-is-second.css' => ('css/body.css', 'css/import-rule.css'));

get '/' => sub { } => 'first';

get '/second' => sub { } => 'second';

app->start;

__DATA__
@@ css/body.css
body {
  font-size: 50px;
  font-family: Montserrat;
}

@@ css/import-rule.css
@import url('https://fonts.googleapis.com/css?family=Montserrat');

@@ first.html.ep
% layout 'import', asset => 'import-is-first.css';

@@ second.html.ep
% layout 'import', asset => 'import-is-second.css';

@@ layouts/import.html.ep
<!doctype html>

<html lang="en">
<head>
  <meta charset="utf-8">

  <title>Nanananana Batman!</title>

  %= asset $asset;

  <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>

<body>

<div>Nanananana Batman!</div>
<br>
<div>Asset = <%= $asset %><div>

<ul>
  <li>Import is packed <a href="<%= url_for 'first' %>">first</a></li>
  <li>Import is packed <a href="<%= url_for 'second' %>">second</a></li>
</ul>

</body>
</html>
