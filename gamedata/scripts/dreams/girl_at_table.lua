local girl_at_table = rfr.add_entity()
rfr.set_image(girl_at_table, ASSETS.images.girl)
rfr.set_image_source(girl_at_table, 12 * 32, 0, 32, 32)
rfr.set_location(girl_at_table, "Map.Dream")
rfr.set_position(girl_at_table, 168, 112)
rfr.set_zindex(girl_at_table, 0)
return girl_at_table
