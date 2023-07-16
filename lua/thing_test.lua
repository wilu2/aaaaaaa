local mysql =require "resty.mysql"
local json =require "cjson"
local busted =require "busted"

describe("Login handler",function()
    local function create_mysql_connection()
        --test code
    end

    describe("login_handler",function()
        it("should return error for invalid parameters",function()
            ngx.req.get_method = function() return "POST" end
            ngx.req.set_uri_args({action = "login"})
            ngx.req.set_post_args({})

            login_handler()

            assert.equals(ngx.HTTP_BAD_REQUEST,ngx.status)
            assert.equals(json.encode({code = 1,msg = "Invalid parameters"}),ngx.output)
        end)
    end
    )
end
)