return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.14.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 25,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 46,
  properties = {},
  tilesets = {
    {
      name = "objects",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 1,
      margin = 0,
      image = "../graphics/objects.png",
      imagewidth = 238,
      imageheight = 17,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 14,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "top",
      x = 0,
      y = 0,
      width = 25,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["height"] = "15",
        ["width"] = "25"
      },
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 6, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1,
        1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
        1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 8, 2, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 1, 1, 1, 10, 10, 10, 13, 10, 10, 1, 1, 1, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "topObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 6,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "true"
          }
        },
        {
          id = 7,
          name = "sign",
          type = "",
          shape = "rectangle",
          x = 208,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "Press Z to jump"
          }
        },
        {
          id = 14,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top"
          }
        },
        {
          id = 15,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 112,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 144,
          y = 224,
          width = 0,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 26,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 304,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 42,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 43,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 80,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
           -- ["link"] = "fan"
          }
        },
        {
          id = 45,
          name = "fan",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["maxheight"] = "3"
          }
        }
      }
    },
    {
      type = "tilelayer",
      name = "bottom",
      x = 0,
      y = 0,
      width = 25,
      height = 15,
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["height"] = "15",
        ["width"] = "20"
      },
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 2, 0, 8, 0, 0, 0, 8, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 14, 0, 0, 0, 8, 0, 5, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 7, 10, 10, 1, 1, 1, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "bottomObjects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 11,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top",
            ["screen"] = "bottom"
          }
        },
        {
          id = 12,
          name = "sign",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "Yay, touch screen signs!"
          }
        },
        {
          id = 29,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 30,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 208,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 31,
          name = "fan",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "fan",
            ["maxheight"] = "6"
          }
        },
        {
          id = 33,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 34,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 36,
          name = "sensor",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "keyDoor"
          }
        },
        {
          id = 37,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "keyDoor",
            ["locked"] = "true",
            ["start"] = "false"
          }
        },
        {
          id = 38,
          name = "key",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 39,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 208,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "false"
          }
        },
        {
          id = 40,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 144,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["locked"] = "true"
          }
        },
        {
          id = 41,
          name = "sign",
          type = "",
          shape = "rectangle",
          x = 112,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["text"] = "Use a key to unlock locked doors!"
          }
        }
      }
    }
  }
}
