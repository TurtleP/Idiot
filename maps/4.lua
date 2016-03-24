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
  nextobjectid = 23,
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
      visible = false,
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
        1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 13, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 1,
        1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
        1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 13, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 10, 10, 10, 10, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 1, 1, 1, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "topObjects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 1,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 16,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "down",
            ["link"] = "bottom;368;192;"
          }
        },
        {
          id = 3,
          name = "key",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 64,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
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
          id = 5,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 352,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["locked"] = "true"
          }
        },
        {
          id = 6,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 368,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
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
          id = 8,
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
          id = 9,
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
          id = 10,
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
          id = 11,
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
          id = 12,
          name = "spikes",
          type = "",
          shape = "rectangle",
          x = 272,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
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
          id = 14,
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
          id = 15,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "up",
            ["link"] = "bottom;16;112;"
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
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 15, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 1,
        1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 8, 0, 13, 1,
        1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1
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
          id = 16,
          name = "dropper",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "bottom;48;16;"
          }
        },
        {
          id = 17,
          name = "notgate",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 16,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "right",
            ["link"] = "top;192;192;"
          }
        },
        {
          id = 19,
          name = "pressureplate",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 336,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["link"] = "bottom;336;112;",
            ["locked"] = "true"
          }
        },
        {
          id = 21,
          name = "pipe",
          type = "",
          shape = "rectangle",
          x = 368,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["direction"] = "left",
            ["link"] = "top;192;16;"
          }
        }
      }
    }
  }
}
