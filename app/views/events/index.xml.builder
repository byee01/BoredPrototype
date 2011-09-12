xml.events do
  xml.categories('A,B,C')
  @events.each do |event_obj|
    xml.event(:id => event_obj.id) do
      xml.name(event_obj.name)
      xml.description(event_obj.description)
      xml.datetime(event_obj.time)
      xml.image(event_obj.flyer)
      xml.categories(event_obj.categories)
    end
  end
end
