

module Decompress = struct

  external decoder_version : unit -> string = "ml_brotli_decoder_version"

  external bytes :
    ?custom_dictionary:bytes -> bytes -> bytes = "ml_brotli_decompress"

  let version = decoder_version ()

end

module Compress = struct

  external encoder_version : unit -> string = "ml_brotli_encoder_version"

  let version = encoder_version ()

  type mode = Generic | Text | Font

  type quality = [`_0 | `_1 | `_2 | `_3 | `_4 | `_5 |
                  `_6 | `_7 | `_8 | `_9 | `_10 | `_11]

  type lgwin = [`_10 | `_11 | `_12 | `_13 | `_14
               | `_15 | `_16 | `_17 | `_18 | `_19
               | `_20 | `_21 | `_22 | `_23 | `_24]

  type lgblock = [`_0 | `_16 | `_17 | `_18 | `_19
                 | `_20 | `_21 | `_22 | `_23 | `_24]

  type params = {mode : int; quality : int; lgwin : int; lgblock : int }

  let int_of_mode = function
    | Generic -> 0
    | Text -> 1
    | Font -> 2

  let int_of_quality (x : quality) = match x with
    | `_0 -> 0 | `_1 -> 1 | `_2 -> 2 | `_3 -> 3 | `_4 -> 4 | `_5 -> 5
    | `_6 -> 6 | `_7 -> 7 | `_8 -> 8 | `_9 -> 9 | `_10 -> 10 | `_11 -> 11

  let int_of_lgwin (x : lgwin) = match x with
    | `_10 -> 10 | `_11 -> 11 | `_12 -> 12 | `_13 -> 13 | `_14 -> 14
    | `_15 -> 15 | `_16 -> 16 | `_17 -> 17 | `_18 -> 18 | `_19 -> 19
    | `_20 -> 20 | `_21 -> 21 | `_22 -> 22 | `_23 -> 23 | `_24 -> 24

  let int_of_lgblock (x : lgblock) = match x with
    | `_0 | `_16 -> 16 | `_17 -> 17 | `_18 -> 18 | `_19 -> 19
    | `_20 -> 20 | `_21 -> 21 | `_22 -> 22 | `_23 -> 23 | `_24 -> 24

  let make_params m q lgw lgb =
    { mode = int_of_mode m; quality = int_of_quality q;
      lgwin = int_of_lgwin lgw; lgblock = int_of_lgblock lgb }

  external compress_bytes :
    bytes option -> params -> bytes -> bytes = "ml_brotli_compress"

  let bytes
      ?(mode=Generic)
      ?(quality : quality = `_11)
      ?(lgwin : lgwin = `_22)
      ?(lgblock : lgblock = `_0)
      ?custom_dictionary
      data =
    compress_bytes
      custom_dictionary
      (make_params mode quality lgwin lgblock)
      data

end
