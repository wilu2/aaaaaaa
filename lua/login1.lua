local json = require "cjson"
local mysql = require "mysql"

-- 创建MySQL连接池
local function create_mysql_connection()
    local db = mysql:new()
    return db
end

-- 登录处理函数
local function login_handler()
    ngx.req.read_body()
    local args = ngx.req.get_post_args()

    local username = args.username
    local password = args.password

    if not (username and password) then
        ngx.status = ngx.HTTP_BAD_REQUEST
        ngx.say(json.encode({code = 1, msg = "Invalid parameters"}))
        return
    end

    local db = create_mysql_connection()
    if not db then
        ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
        ngx.say(json.encode({code = 1, msg = "Failed to connect to database"}))
        ngx.log(ngx.ERR, "Failed to connect to database: ", err)
        return
    end

    local sql = "SELECT * FROM user WHERE username = " .. ngx.quote_sql_str(username)
    local res, err = db:query(sql)
    if not res then
        ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
        ngx.say(json.encode({code = 1, msg = "Failed to execute query"}))
        ngx.log(ngx.ERR, "Failed to execute query: ", err)
        return
    end

    if #res == 0 or res[1].password ~= password then
        ngx.say(json.encode({code = 1, msg = "Invalid username or password"}))
        return
    end

    ngx.say(json.encode({code = 0, msg = "Login successful"}))
    db:close()
end
-- 处理登录请求
ngx.req.read_body()
local uri_args = ngx.req.get_uri_args()

if ngx.req.get_method() == "POST" and uri_args and uri_args.action == "login" then
    login_handler()
else
    ngx.status = ngx.HTTP_NOT_FOUND
    ngx.say("Page not found")
end
