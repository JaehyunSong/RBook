function Link(elem)
  if(elem.target:sub(1, 1) ~= '#') then
    elem.attributes.target = '_blank'
    elem.attributes.rel = 'external'
  end
  return elem
end