function publishToWiki (script_file, usr_name, usr_pw)
# Does currently not work (API disabled).
wiki_api = "http://wiki.octave.org/api.php";

# Use formatter "__publish_wiki_output__.m"
opts.format = "wiki";
output_file = publish (script_file, opts);
[~,page] = fileparts (script_file);

# Extract images
path = fileparts (output_file);
imgs = fileread (output_file);
imgs = regexp (imgs, '\[\[File:([^|]*)', "tokens");
imgs = fullfile (path, [imgs{:}]);
del_idx = [];
for i = 1:length(imgs)
  if (! exist (imgs{i}, "file"))
    del_idx = [del_idx, i];
    warning ("publishToWiki: cannot find %s", imgs{i});
  endif
endfor
imgs(del_idx) = [];
imgs = strjoin (imgs, " ");

# Write to wiki with helper BASH script
system (sprintf ("./wikiLogin.sh %s %s %s %s %s %s", wiki_api, ...
  usr_name, usr_pw, page, output_file, imgs));
endfunction
