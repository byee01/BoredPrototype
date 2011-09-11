xml.events do
  xml.categories('3')
  @events.each do |event_obj|
    xml.event {
      xml.name(event_obj.name)
      xml.description(event_obj.description)
      xml.datetime(event_obj.time)
      xml.image(event_obj.flyer)
      xml.categories(event_obj.categories)
    }
  end
end
