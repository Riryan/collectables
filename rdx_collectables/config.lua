Config = {}

Config.Locale = 'en'

Config.Enabled = true
Config.Debug = false
Config.DrawDistance = 50
Config.PlaceCollectables = true

Config.MenuKey = 0x156F7119
Config.MenuPosition = 'top-left'

Config.Collectables = {
    Arrowheads = {
        Enabled = true,
        ID = 'arrowheads',
        Prop = 'arrows',
        Blip = {
            ID = -810005617,
            Color = 4,
            Scale = 0.8,
        },
        Items = {
            { ID=0, Pos = vector3(756,256,6) }
           

        }
    },
    Coins = {
        Enabled = true,
        ID = 'coins',
        Prop = 'arrows',
        Blip = {
            ID = -810005617,
            Color = 4,
            Scale = 0.8,
        },
        Items = {
            { ID=0, Pos = vector3(756,256,6) }
          

        }
    },

    Cards = {
        Enabled = true,
        ID = 'cards',
        Prop = 'prop_power_cell',
        Blip = {
            ID = -810005617,
            Color = 24,
            Scale = 0.9,
        }, 
        Items = {
            { ID=0, Pos = vector3(338.5,-2762,43.62) },
            { ID=1, Pos = vector3(470,-731,27.36) }
 


        }
    },

    Jewelery = {
        Enabled = true,
        ID = 'Jewelery',
        Prop = 'prop_security_case_01',
        Blip = {
            ID = -810005617,
            Color = 5,
            Scale = 0.9,
        },
        Items = {
            { ID=0, Pos = vector3(-998.5,6538.5,-30.5) },
            { ID=1, Pos = vector3(-1075.5,4897.5,214) }        
        }
    },

    Eggs = {
        Enabled = true,
        ID = 'eggs',
        Prop = 'prop_rad_waste_barrel_01',
        Blip = {
            ID = -810005617,
            Color = 1,
            Scale = 0.9,
        },
        Items = {
            { ID=0, Pos = vector3(-1435,5783,-29) },
            { ID=1, Pos = vector3(-1267,6261.5,-34) }
        }
    },

    Bottles = {
        Enabled = true,
        ID = 'bottles',
        Prop = 'prop_sub_chunk_01',
        Blip = {
            ID = -810005617,
            Color = 3,
            Scale = 0.9,
        },
        Items = {
            { ID=0, Pos = vector3(-909.5,6655.5,-33.5) },
            { ID=1, Pos = vector3(-3398,3718,-86) }        
        }
    },

    Flowers = {
        Enabled = true,
        ID = 'flowers',
        Prop = 'prop_time_capsule_01',
        Blip = {
            ID = -810005617,
            Color = 50,
            Scale = 1.0,
        },
        Items = {
            { ID=0, Pos = vector3(502,5604,798) },
            { ID=1, Pos = vector3(-1725.5,-190,58.5) }
        }  
    }
}