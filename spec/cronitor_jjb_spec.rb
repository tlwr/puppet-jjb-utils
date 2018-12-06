require_relative 'spec_helper'

describe 'cronitor_jjb' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  context 'arg parsing' do
    it 'should raise an error if there are not enough arguments' do
      expect { scope.function_cronitor_jjb([]  ) }.to raise_error
      expect { scope.function_cronitor_jjb(['']) }.to raise_error
    end
  end

  context 'job parsing' do
    it 'should raise an error if there are no jobs' do
      expect {
        scope.function_cronitor_jjb(['', 'abcdef', false, false])
      }.to raise_error
    end
  end

  context 'builder' do
    it 'should add a builder even if no builder block exists' do
      result = scope.function_cronitor_jjb([
        '- job: {name: test}', 'abcdef', true, false
      ])

      job = YAML.load(result)[0]['job']

      expect( job['builders']        ).to_not eq(nil)
      expect( job['builders'].length ).to     eq(1)
    end

    it 'should add a builder to the front' do
      template = [
        '---',
        '- job:',
        '    name: test',
        '    builders:',
        '      - shell: echo test',
      ].join("\n")

      result = scope.function_cronitor_jjb([template, 'abcdef', true, false])
      job    = YAML.load(result)[0]['job']

      expect( job['builders']        ).to_not eq(nil)
      expect( job['builders'].length ).to     eq(2)
      expect( job['builders'][1]     ).to     eq({ 'shell' => 'echo test' })

      expect( job['builders'][0] ).to eq({
        'shell' => "curl -sf 'https://cronitor.link/abcdef/run'"
      })
    end
  end

  context 'publisher' do
    it 'should add a publisher even if no publisher block exists' do
      result = scope.function_cronitor_jjb([
        '- job: {name: test}', 'abcdef', false, true
      ])

      job = YAML.load(result)[0]['job']

      expect( job['publishers']        ).to_not eq(nil)
      expect( job['publishers'].length ).to     eq(1)
    end

    it 'should add a publisher to the end' do
      template = [
        '---',
        '- job:',
        '    name: test',
        '    publishers:',
        '      - archive:',
        "          artifacts: '*.zip'",
      ].join("\n")

      result = scope.function_cronitor_jjb([template, 'abcdef', false, true])
      job    = YAML.load(result)[0]['job']

      expect( job['publishers']        ).to_not eq(nil)
      expect( job['publishers'].length ).to     eq(2)

      expect( job['publishers'][0] ).to eq({
        'archive' => { 'artifacts' => '*.zip' }
      })

      expect( job['publishers'][1] ).to eq([{
        'conditional-publisher' => [{
          'condition-kind'  => 'current-status',
          'condition-best' =>  'SUCCESS',
          'condition-worst' => 'SUCCESS',
          'action'          => [
            {
              'postbuildscript' => {
                'builders' => [{
                  'shell' => "curl -sf 'https://cronitor.link/abcdef/complete'"
                }]
              }
            }
          ]
        }]
      }])
    end
  end
end
