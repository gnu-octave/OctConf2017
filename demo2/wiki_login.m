function wiki_login(wiki_api, username, password)
#
#

wiki_api = char ("http://wiki.octave.org/wiki/api.php");
username = char ("siko1056");
password = char ("werner1988");

# Establish cookie management
cookie_manager = javaObject ("java.net.CookieManager");
javaMethod ("setCookiePolicy", cookie_manager, ...
  java_get ("java.net.CookiePolicy", "ACCEPT_ALL"));
javaMethod ("setDefault", "java.net.CookieHandler", cookie_manager);

disp ("Login (1/2): Get login token...");
url = javaObject ("java.net.URL", ...
  [wiki_api, "?action=query&meta=tokens&type=login&format=json"]);

content = read_from_connection (url.openConnection());
if (! isempty (content))
  logintoken = regexp (content{1}, '.*"logintoken":"(\S+)+".*', "tokens");
  if (! isempty (logintoken))
    logintoken = logintoken{1};
    logintoken = logintoken{1};
    logintoken = logintoken(1:end-1);  # '+\\' to '+\'
    disp (["    SUCCESS: token is: ", logintoken]);
  else
    error ("Could not retrieve login token.");
  endif
endif


disp ("Login (2/2): Logging in...");
url = javaObject ("java.net.URL", ...
  [wiki_api, "?action=clientlogin&format=json"]);

keys = {"username", "password", "rememberMe", "logintoken", "loginreturnurl"};
vals = {username,   password,   "1",          logintoken,   wiki_api};
post_data = build_HTTP_header (keys, vals);

connection = url.openConnection();
javaMethod ("setRequestMethod", connection, "POST");
#javaMethod ("setRequestProperty", connection, "Content-Type", ...
#  "application/x-www-form-urlencoded");
#connection.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
javaMethod ("setDoOutput", connection, true);
javaMethod ("write", connection.getOutputStream (), post_data);

content = read_from_connection (connection);
if (! isempty (content))
  username = regexp (content{1}, '.*"username":"([^"]*).*', "tokens");
  status = regexp (content{1}, '.*"status":"([^"]*).*', "tokens");
  if (! isempty (username))
    username = username{1};
    username = username{1};
    disp (["    SUCCESS: logged in as ", username]);
  elseif (! isempty (status))
    status = status{1};
    error ("    FAILED: STATUS is %s", status{1});
  else
    error ("Could not retrieve login token.");
  endif
endif


disp ("Edit (1/3): Get edit token...");
url = javaObject ("java.net.URL", ...
  [wiki_api, "?action=query&meta=tokens&format=json"]);

content = read_from_connection (url.openConnection());
if (! isempty (content))
  csrftoken = regexp (content{1}, '.*"csrftoken":"(\S+)+".*', "tokens");
  if (! isempty (csrftoken))
    csrftoken = csrftoken{1};
    csrftoken = csrftoken{1};
    csrftoken = csrftoken(1:end-1);  # '+\\' to '+\'
    disp (["    SUCCESS: token is: ", csrftoken]);
  else
    error ("Could not retrieve login token.");
  endif
endif


%{
echo "Edit (2/3): Update page ${PAGE}..."
echo " "
CR=$(curl -S \
  --cookie $cookie_jar \
  --cookie-jar $cookie_jar \
  --data-urlencode "title=${PAGE}" \
  --data-urlencode "text=${CONTENT}" \
  --data-urlencode "token=${EDITTOKEN}" \
  "${wiki_api}?action=edit&format=json")
echo " "
#echo "$CR" | jq .

echo "Edit (3/3): Update images of ${PAGE}..."
echo " "
for ((i=6 ; i <= $# ; i++)); do
    echo "  Image ($(expr $i - 5)/$(expr $# - 5)): ${!i}"
    echo " "
    FNAME=$(basename "${!i}")
    CR=$(curl -S \
      --cookie $cookie_jar \
      --cookie-jar $cookie_jar \
      --form "filename=$FNAME" \
      --form "file=@${!i}" \
      --form "ignorewarnings=1" \
      --form "token=${EDITTOKEN}" \
      "${wiki_api}?action=upload&format=json")
    echo " "
    # echo "$CR" | jq .
done
%}

endfunction


function content = read_from_connection (connection)
#
#

inStrReader = javaObject ("java.io.InputStreamReader", ...
  connection.getInputStream ());
buffReader =  javaObject ("java.io.BufferedReader", inStrReader);

content = cell();
i = 0;
do
  i += 1;
  content{i} = buffReader.readLine();
until (isnumeric (content{i}) && isempty (content{i}))

buffReader.close();
content = content(1:end-1);
endfunction


function data_bytes = build_HTTP_header (keys, values)
#
#

if (length(keys) != length (values))
  error ("Incomplete key-value pairs");
endif

data = javaObject ("java.lang.StringBuilder");
for i = 1:length(keys)
  if (i != 1)
    javaMethod ("append", data, "&");
  endif
  key = javaMethod ("encode", "java.net.URLEncoder", keys{i}, "UTF-8");
  javaMethod ("append", data, key);
  javaMethod ("append", data, "=");
  value = javaMethod ("encode", "java.net.URLEncoder", values{i}, "UTF-8");
  javaMethod ("append", data, value);
endfor
data_bytes = int8 (data.toString ()); % we really need bytes here
data_bytes = data_bytes(:);
endfunction
