return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.15.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 25,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 14,
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
      properties = {
        ["height"] = "15",
        ["width"] = "25"
      },
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 6, 0, 8, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 5, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 6, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 8, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 8, 0, 8, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
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
          id = 1,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "true"
          }
        },
        {
          id = 2,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "box",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 48,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "key",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["locked"] = "true"
          }
        },
        {
          id = 9,
          name = "andgate",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top;32;64-top;192;112;"
          }
        },
        {
          id = 10,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "top;336;176;",
            ["locked"] = "true"
          }
        },
        {
          id = 13,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 368,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
