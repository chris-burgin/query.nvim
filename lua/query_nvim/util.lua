local Job = require('plenary/job')

local util = {}

local state = {
	buf = nil
}

function util.run_job(job_spec)
   Job:new(job_spec):start()
end

function util.hold_and_restore_reg(reg)
	local value = vim.fn.getreg(reg, 1)
	local function restore_reg()
		vim.fn.setreg(reg, value);
	end
	return restore_reg
end

function util.get_query(opts)
	local restore = util.hold_and_restore_reg(opts.query_buf)

	vim.api.nvim_command('normal! gv"'..opts.query_buf..'y')
	local query = vim.fn.getreg(opts.query_buf)

	restore()

	return query
end

function util.create_query_result_buf(lines)
	local reused = false;

	if state.buf == nil then
			state.buf = vim.api.nvim_create_buf(false, true);
	else
		local res = vim.fn.bufwinnr(state.buf)
		if res == -1 then
			state.buf = vim.api.nvim_create_buf(false, true);
		else
			reused = true;
		end
	end

	vim.api.nvim_buf_set_lines(state.buf, 0, -1, true, lines)

	if reused == false then
		vim.api.nvim_command("split")
		vim.api.nvim_set_current_buf(state.buf)
	end
end

function util.split_on_space(str)
	if string.find(str, ",") then
		chunks = {}
		for substring in str.gmatch(str, '([^,]+)') do
			 table.insert(chunks, substring)
		end
		return chunks;
	end

	return {str}
end

function util.join(list)
	local str = "";
		for key, substr in pairs(list) do
			if key == 0 then
				str = substr
			else
				str = str.." "..substr
			end
		end

	return str
end

return util

