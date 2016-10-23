return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 25,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 27,
  properties = {},
  tilesets = {
    {
      name = "base",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 1,
      margin = 0,
      image = "../graphics/objects.png",
      imagewidth = 340,
      imageheight = 17,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 20,
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
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 8, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1,
        1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 1, 17, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1,
        1, 0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 0, 1,
        1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 1, 0, 0, 1, 7, 0, 0, 0, 0, 0, 0, 0, 7, 1, 0, 0, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1,
        1, 6, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 8, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 6, 1,
        1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "topObjects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "door",
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
          id = 5,
          name = "laser",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top;192;80;",
            ["width"] = 9
          }
        },
        {
          id = 6,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
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
          id = 17,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top;192;80;"
          }
        },
        {
          id = 18,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 368,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "andgate",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 80,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top;16;208;-top;368;208;"
          }
        },
        {
          id = 20,
          name = "fan",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["maxheight"] = "9"
          }
        },
        {
          id = 21,
          name = "fan",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["maxheight"] = "9"
          }
        },
        {
          id = 22,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 224,
          width = 64,
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
          x = 288,
          y = 224,
          width = 64,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
