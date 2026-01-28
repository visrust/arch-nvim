local M = {}

-- Helper function to create conditional rules
local function create_rule(...)
  local Rule = require('nvim-autopairs.rule')
  return Rule(...)
end

local function get_conds()
  return require('nvim-autopairs.conds')
end

local function get_ts_conds()
  return require('nvim-autopairs.ts-conds')
end

-- ============================================
-- LANGUAGE-SPECIFIC RULES
-- ============================================

function M.setup(npairs)
  local Rule = require('nvim-autopairs.rule')
  local cond = get_conds()
  local ts_cond = get_ts_conds()
  
  -- ==========================================
  -- JAVASCRIPT / TYPESCRIPT
  -- ==========================================
  npairs.add_rules({
    -- Arrow functions: () => {  }
    Rule('%(.*%)%s*%=>$', ' {  }', {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    })
      :use_regex(true)
      :set_end_pair_length(2),
    
    -- Template literals
    Rule('$', '$', {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    })
      :with_pair(cond.before_regex('%{'))
      :with_move(function(opts) return opts.char == '$' end),
  })
  
  -- ==========================================
  -- PYTHON
  -- ==========================================
  npairs.add_rules({
    -- f-strings
    Rule('f"', '"', 'python')
      :with_pair(cond.none())
      :use_key('"'),
    
    Rule("f'", "'", 'python')
      :with_pair(cond.none())
      :use_key("'"),
    
    -- Triple quotes for docstrings
    Rule('"""', '"""', 'python')
      :with_move(cond.none())
      :with_pair(function(opts)
        return opts.line:sub(opts.col - 2, opts.col - 1) == '""'
      end),
    
    Rule("'''", "'''", 'python')
      :with_move(cond.none())
      :with_pair(function(opts)
        return opts.line:sub(opts.col - 2, opts.col - 1) == "''"
      end),
  })
  
  -- ==========================================
  -- RUST
  -- ==========================================
  npairs.add_rules({
    -- Generics: Vec<T>
    Rule('<', '>', 'rust')
      :with_pair(cond.before_regex('[%w:]'))
      :with_move(function(opts) return opts.char == '>' end),
    
    -- Lifetime annotations: 'a
    Rule("'", '', 'rust')
      :with_pair(cond.not_after_regex('[%w]'))
      :with_move(cond.none()),
    
    -- Macros: println!()
    Rule('!%(', ')', 'rust')
      :use_key('(')
      :replace_endpair(function(opts)
        return opts.prev_char == '!' and ')' or ''
      end),
  })
  
  -- ==========================================
  -- C / C++
  -- ==========================================
  npairs.add_rules({
    -- Templates: std::vector<int>
    Rule('<', '>', {'c', 'cpp'})
      :with_pair(cond.before_regex('[%w:]'))
      :with_move(function(opts) return opts.char == '>' end),
    
    -- Preprocessor directives (don't pair)
    Rule('#', '', {'c', 'cpp'})
      :with_pair(cond.none()),
  })
  
  -- ==========================================
  -- GO
  -- ==========================================
  npairs.add_rules({
    -- Generics (Go 1.18+)
    Rule('<', '>', 'go')
      :with_pair(cond.before_regex('[%w]'))
      :with_move(function(opts) return opts.char == '>' end),
    
    -- Struct tags: `json:"name"`
    Rule('`', '`', 'go')
      :with_pair(ts_cond.is_not_ts_node({'string'})),
  })
  
  -- ==========================================
  -- RUBY
  -- ==========================================
  npairs.add_rules({
    -- do...end blocks
    Rule('do$', 'end', 'ruby')
      :use_regex(true)
      :with_cr(cond.none()),
    
    -- String interpolation: #{}
    Rule('#{', '}', 'ruby')
      :with_pair(ts_cond.is_ts_node({'string'})),
  })
  
  -- ==========================================
  -- LUA
  -- ==========================================
  npairs.add_rules({
    -- String concatenation (..)
    Rule('%.%.', '', 'lua')
      :with_pair(cond.none()),
    
    -- Percent in strings
    Rule('%', '%', 'lua')
      :with_pair(ts_cond.is_ts_node({'string'})),
  })
  
  -- ==========================================
  -- HTML / XML / JSX / TSX
  -- ==========================================
  npairs.add_rules({
    -- Auto-close tags: <div></div>
    Rule('<', '>', {
      'html',
      'xml',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
    })
      :with_pair(cond.before_regex('[^%w]'))
      :with_move(function(opts) return opts.char == '>' end),
    
    -- Self-closing tags: <img />
    Rule('<', ' />', {
      'html',
      'xml',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'svelte',
    })
      :with_pair(cond.before_regex('[%w]'))
      :only_cr(),
  })
  
  -- ==========================================
  -- JAVA
  -- ==========================================
  npairs.add_rules({
    -- Generics: List<String>
    Rule('<', '>', 'java')
      :with_pair(cond.before_regex('[%w]'))
      :with_move(function(opts) return opts.char == '>' end),
  })
  
  -- ==========================================
  -- SQL
  -- ==========================================
  npairs.add_rules({
    -- Single quotes for strings (not after letters)
    Rule("'", "'", 'sql')
      :with_pair(cond.not_after_regex('[%w]')),
  })
  
  -- ==========================================
  -- SHELL / BASH
  -- ==========================================
  npairs.add_rules({
    -- Command substitution: $()
    Rule('$(', ')', {'sh', 'bash', 'zsh'})
      :with_move(cond.none()),
    
    -- Variable expansion: ${}
    Rule('${', '}', {'sh', 'bash', 'zsh'})
      :with_move(cond.none()),
  })
  
  -- ==========================================
  -- PHP
  -- ==========================================
  npairs.add_rules({
    -- Array shorthand: []
    Rule('[', ']', 'php')
      :with_pair(cond.before_regex('[^%w]')),
    
    -- Arrow functions: =>
    Rule('=', '>', 'php')
      :with_pair(cond.before_regex('[%s]'))
      :with_move(cond.none()),
  })
  
  -- ==========================================
  -- MARKDOWN
  -- ==========================================
  npairs.add_rules({
    -- Code blocks: ```
    Rule('``', '`', 'markdown')
      :with_pair(function(opts)
        return opts.line:sub(opts.col - 1, opts.col - 1) == '`'
      end),
    
    -- Inline code: `code`
    Rule('`', '`', 'markdown')
      :with_pair(cond.not_after_regex('[`]')),
  })
  
  -- ==========================================
  -- JSON
  -- ==========================================
  npairs.add_rules({
    -- Don't pair single quotes (JSON uses double quotes)
    Rule("'", '', 'json')
      :with_pair(cond.none()),
  })
  
  -- ==========================================
  -- CSS / SCSS / LESS
  -- ==========================================
  npairs.add_rules({
    -- CSS blocks
    Rule('{', '  }', {'css', 'scss', 'less'})
      :with_pair(cond.before_regex('[^%w]'))
      :set_end_pair_length(2),
  })
end

-- ============================================
-- UTILITY: ADD CUSTOM RULE AT RUNTIME
-- ============================================

-- Usage: require('autopairs.language-rules').add_custom_rule(...)
function M.add_custom_rule(open, close, filetypes, conditions)
  local npairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')
  local rule = Rule(open, close, filetypes)
  
  if conditions then
    for _, condition in ipairs(conditions) do
      rule = rule:with_pair(condition)
    end
  end
  
  npairs.add_rule(rule)
end

-- ============================================
-- UTILITY: LIST ALL ACTIVE RULES
-- ============================================

function M.list_rules(filetype)
  local npairs = require('nvim-autopairs')
  local ft = filetype or vim.bo.filetype
  local rules = npairs.get_rules(ft)
  
  print('=== Autopairs Rules for', ft, '===')
  for _, rule in ipairs(rules) do
    print(string.format('  %s → %s', rule.start_pair, rule.end_pair))
  end
end

return M
