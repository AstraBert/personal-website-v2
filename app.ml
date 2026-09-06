open Base
open Stdio

type blog_entry_base = {frontmatter: string; content: string}
type blog_entry_details = {
  mutable publishDate: string;
  mutable author: string;
  mutable title: string;
  mutable category: string;
  mutable excerpt: string;
}
type blog_entry = { details: blog_entry_details; content: string; name: string }

let read_file file =
 In_channel.read_all file

let write_file path content =
  Out_channel.write_all path ~data:content

let ensure_dir path = if not (Stdlib.Sys.file_exists path) then
    Stdlib.Sys.mkdir path 0o755

let read_dir path = let arr = Stdlib.Sys.readdir path in
  let ls = Array.to_list arr in
  let mapped = List.map ~f:(fun e -> (String.rstrip ~drop:(fun c -> Char.equal c '/') path) ^ "/" ^ e) ls in
  mapped

let blog_template = read_file "pages/blog.tpl"
let blog_list_template = read_file "pages/blog-list.tpl"
let blog_list_entry_template = read_file "pages/blog-list-entry.tpl"

(* regex for frontmatter: ^---([\s\S]+?)--- *)
let regex = Re.Pcre.re "---" |> Re.compile
let split_on_yaml_delimiter content = (let els = Re.split regex content in
  if List.length els > 1
  then {frontmatter = List.nth_exn els 0; content = String.concat ~sep:"---" (List.sub els ~pos:1 ~len: ((List.length els) - 1))}
  else raise (Failure "Expected to find a frontmatter")
)

let get_blog_entry_details frontmatter =
  let details = { publishDate = ""; author = ""; title = ""; category = ""; excerpt = "" } in
  let lines = String.split_lines frontmatter in
  let f elem =
    if String.is_prefix elem ~prefix:"publishDate:" then
      details.publishDate <- String.strip (List.nth_exn (String.split elem ~on:':') 1)
    else if String.is_prefix elem ~prefix:"title:" then
      details.title <- String.strip (List.nth_exn (String.split elem ~on:':') 1)
    else if String.is_prefix elem ~prefix:"category:" then
      details.category <- String.strip (List.nth_exn (String.split elem ~on:':') 1)
    else if String.is_prefix elem ~prefix:"author:" then
      details.author <- String.strip (List.nth_exn (String.split elem ~on:':') 1)
    else if String.is_prefix elem ~prefix:"excerpt:" then
      details.author <- String.strip (List.nth_exn (String.split elem ~on:':') 1)
    else ()
  in
  List.iter ~f:f lines;
  details

let make_blog_entry path = (
  let content = read_file path in
  let base = split_on_yaml_delimiter content in
  let details = get_blog_entry_details base.frontmatter
  in { details = details; content = base.content; name = ("generated/" ^ (String.substr_replace_all ~pattern:".md" ~with_:".html" path)) }
)

let render_to_html content = Cmarkit.Doc.of_string content
  |> Hilite_markdown.transform
  |> Cmarkit_html.of_doc ~safe:false

let render_template entry = (
  let with_title = String.substr_replace_all ~pattern:"{{ title }}" ~with_:entry.details.title blog_template
  in let with_excerpt = String.substr_replace_all ~pattern:"{{ excerpt }}" ~with_:entry.details.excerpt with_title
  in let with_author = String.substr_replace_all ~pattern:"{{ author }}" ~with_:entry.details.author with_excerpt
  in let with_category = String.substr_replace_all ~pattern:"{{ category }}" ~with_:entry.details.category with_author
  in let with_publishdate = String.substr_replace_all ~pattern:"{{ publishDate }}" ~with_:entry.details.publishDate with_category
  in let with_content = String.substr_replace_all ~pattern:"{{ content }}" ~with_:(render_to_html entry.content) with_publishdate in
  with_content
)

let render_blog_list_entry entry = (
  let with_title = String.substr_replace_all ~pattern:"{{ title }}" ~with_:entry.details.title blog_list_entry_template
  in let with_url = String.substr_replace_all ~pattern:"{{ url }}" ~with_:("./" ^ (String.substr_replace_first ~pattern:"generated/blog/" ~with_:"" entry.name)) with_title
  in let with_category = String.substr_replace_all ~pattern:"{{ category }}" ~with_:entry.details.category with_url
  in let with_excerpt = String.substr_replace_all ~pattern:"{{ excerpt }}" ~with_:entry.details.excerpt with_category in
  with_excerpt
)

let sort_by_date_desc entries =
  List.sort entries ~compare:(fun a b -> String.compare b.details.publishDate a.details.publishDate)

let render_blog_list entries = (
  let sorted_entries = sort_by_date_desc entries in
  let rendered_entries = List.map ~f:render_blog_list_entry sorted_entries in
  let concatenated = String.concat ~sep:"\n\n" rendered_entries in
  let blog_list = String.substr_replace_all ~pattern:"{{ entries }}" ~with_:concatenated blog_list_template in
  blog_list
)

let md_blog_to_html_page entry = (
  let rendered = render_template entry in
  (entry.name, rendered)
)

let () = ensure_dir "generated"
let () = ensure_dir "generated/blog"
let dir_entries = read_dir "blog"
let entries = List.map ~f:make_blog_entry dir_entries
let contents = List.map ~f:md_blog_to_html_page entries
let blog_index = render_blog_list entries
let _ = List.map ~f:(fun e -> write_file (fst e) (snd e)) contents
let () = write_file "generated/blog/index.html" blog_index

(* Uncomment for local testing *)
(* let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/" (Dream.from_filesystem "pages" "index.html");
    Dream.get "/static/**" (Dream.static "static");
    Dream.get "/blog" (Dream.from_filesystem "generated/blog" "index.html");
    Dream.get "/blog/**" (Dream.static "generated/blog")
  ] *)
