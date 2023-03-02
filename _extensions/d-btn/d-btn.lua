-- Quarto Extension (Shortcode)
--   d-btn: Download Button
-- Author: Jaehyun Song
-- Update: 2023/03/02

return {
  ['d-btn'] = function(args, kwargs, meta)
    local filename = pandoc.utils.stringify(args[1])
    local code1 = "<span class='rn4e_btn'><a href='Data/"
    local code2 = "' download='"
    local code3 = "'>Download</a>"
    local full_code = code1 .. filename .. code2 .. filename .. code3

    quarto.doc.add_html_dependency({
      name = "d-btn",
      stylesheets = {"resources/css/d-btn.css"}
    })

    return pandoc.RawBlock("html", full_code)
  end
}
