let read_file file =
 In_channel.with_open_bin file In_channel.input_all

let index = read_file "pages/index.html"

let () =
  Dream.run
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html index);
    Dream.get "/static/**" (Dream.static "static")
  ]
