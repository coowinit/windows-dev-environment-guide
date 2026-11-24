'use strict';
// Tests the actual viewer parsing and classification functions without a browser.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const root = path.resolve(__dirname, '..');
const source = fs.readFileSync(path.join(root, 'assets/js/report.js'), 'utf8');
// Load declarations only; UI event handlers below this boundary require a DOM.
const boundary = source.indexOf('let loadSequence=0;');
assert.ok(boundary > 0, 'Viewer source boundary changed; update tests');
const ctx = vm.createContext({});
vm.runInContext(source.slice(0, boundary) + '\nthis.api={parse,category,tally};', ctx);
const {parse} = ctx.api;
const read = name => fs.readFileSync(path.join(root, name), 'utf8');
const plain = x => JSON.parse(JSON.stringify(x));
let count = 0;
function test(name, fn) { fn(); count++; console.log('PASS: ' + name); }
const sample = read('examples/environment-report.json');
test('53 rows and summary', () => { const d=parse(sample); assert.equal(d.rows.length,53); assert.deepEqual(plain(d.summary),{PASS:50,WARN:0,FAIL:0,SKIP:3}); assert.equal(d.mismatch,false); });
test('UTF-8 BOM', () => assert.equal(parse('\uFEFF'+sample).rows.length,53));
test('categories', () => { const d=parse(sample); const counts={}; for(const r of d.rows) counts[r.category]=(counts[r.category]||0)+1; assert.deepEqual(counts,{'PowerShell':2,'Python':3,'Node.js':4,'Git / GitHub':6,'VS Code':14,'PHP / XAMPP / MariaDB':23,'AI 开发环境':1}); });
test('mixed statuses', () => assert.deepEqual(plain(parse(read('tests/fixtures/mixed-status.json')).summary),{PASS:48,WARN:1,FAIL:1,SKIP:3}));
test('summary mismatch', () => assert.equal(parse(read('tests/fixtures/summary-mismatch.json')).mismatch,true));
test('invalid structure', () => assert.throws(()=>parse(read('tests/fixtures/invalid-report.json'))));
test('malformed JSON', () => assert.throws(()=>parse('{')));
test('unknown status', () => { const d=JSON.parse(sample); d.Results[0].Status='UNKNOWN'; assert.throws(()=>parse(JSON.stringify(d))); });
test('missing Advice', () => { const d=JSON.parse(sample); delete d.Results[0].Advice; assert.throws(()=>parse(JSON.stringify(d))); });
test('unknown module', () => { const d=JSON.parse(sample); d.Results[0].Name='Custom tool'; assert.equal(parse(JSON.stringify(d)).rows[0].category,'其他'); });
test('all skipped', () => { const d=JSON.parse(sample); d.Results.forEach(r=>r.Status='SKIP'); assert.equal(parse(JSON.stringify(d)).summary.SKIP,53); });
test('empty results rejected', () => { const d=JSON.parse(sample); d.Results=[]; assert.throws(()=>parse(JSON.stringify(d))); });
test('oversized result array rejected', () => { const d=JSON.parse(sample); d.Results=Array(10001).fill(d.Results[0]); assert.throws(()=>parse(JSON.stringify(d))); });
if(process.argv[2]) test('user-supplied report parses',()=>{const d=parse(fs.readFileSync(process.argv[2],'utf8')); assert.equal(d.mismatch,false);});
console.log(`${count} checks passed.`);
