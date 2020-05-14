{#- Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}

{%- macro get_src_col_list(tgt_cols) -%}

{%- set col_list = [] -%}

{%- if tgt_cols is iterable -%}

    {%- for columns in tgt_cols -%}

        {%- if columns is string -%}

            {%- set _ = col_list.append(columns) -%}

        {#- If list of lists -#}
        {%- elif columns is iterable and columns is not string -%}

            {%- if columns is mapping -%}

                {%- set _ = col_list.append(columns) -%}

            {%- else -%}

                {%- for cols in columns -%}

                    {%- set _ = col_list.append(cols) -%}

                {%- endfor -%}

            {%- endif -%}

        {%- endif -%}

    {%- endfor -%}
{%- endif -%}

{{ return(col_list) }}

{%- endmacro -%}