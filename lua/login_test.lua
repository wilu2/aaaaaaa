-- 测试 mysql 模块
describe("mysql module", function()
    local mysql = require "mysql"
  
    it("should create a new MySQL connection", function()
      local db = mysql:new()
      assert.is_not_nil(db)
    end)
  
    it("should close the connection", function()
      local db = mysql:new()
      local result, error = db:close()
      assert.is_nil(error)
      assert.equals(1,result)
    end)
  end)
  
  -- 测试 login1.lua 脚本
  describe("login1.lua script", function()
    local login_handler = require "login1"
  
    it("should handle login request with valid username and password", function()
      ngx.req = {
        read_body = function() end,
        get_post_args = function()
          return { username = "12222", password = "1234" }
        end,
        get_method = function() return "POST" end,
        get_uri_args = function() return { action = "login" } end
      }
      ngx.status = 0
      ngx.say_output = {}
  
      login_handler()
  
      assert.are.same({ code = 0, msg = "Login successful" }, ngx.say_output)
      assert.are.equal(200, ngx.status)
    end)
  
    it("should handle login request with invalid username or password", function()
      ngx.req = {
        read_body = function() end,
        get_post_args = function()
          return { username = "user", password = "wrongpassword" }
        end,
        get_method = function() return "POST" end,
        get_uri_args = function() return { action = "login" } end
      }
      ngx.status = 0
      ngx.say_output = {}
  
      login_handler()
  
      assert.are.same({ code = 1, msg = "Invalid username or password" }, ngx.say_output)
      assert.are.equal(200, ngx.status)
    end)
  
    -- 添加更多的测试用例...
  end)
  