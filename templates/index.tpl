{include file='modules_header.tpl'}

  <table cellpadding="0" cellspacing="0">
  <tr>
    <td width="45"><a href="index.php"><img src="images/icon_custom_fields.png" border="0" width="34" height="34" /></a></td>
    <td class="title">
      <a href="../../admin/modules">{$LANG.word_modules}</a>
      <span class="joiner">&raquo;</span>
      {$L.module_name}
    </td>
  </tr>
  </table>

  {include file="messages.tpl"}

  <div class="margin_bottom_large">
    {$L.text_module_intro}
  </div>

  <form action="{$same_page}" method="post" id="custom_fields_form">
    <input type="hidden" name="update_page" value="1" />

    {* only populated when the user explicitly adds a new type through a dialog window *}
    <input type="hidden" name="new_field_type_id" id="new_field_type_id" value="" />

    <div class="sortable_groups" id="{$sortable_id}">
      <input type="hidden" class="sortable__custom_delete_handler" value="cf_ns.delete_row" />
      <input type="hidden" class="sortable__delete_group_handler" value="cf_ns.delete_group" />
      <input type="hidden" class="sortable__class" value="edit_custom_fields" />
      <input type="hidden" class="sortable__edit_tooltip" value="{$L.phrase_edit_field_type}" />
      <input type="hidden" class="sortable__delete_tooltip" value="{$L.phrase_delete_field_type}" />
      <input type="hidden" class="sortable__new_group_name" value="{$LANG.phrase_group_name}" />

    {foreach from=$grouped_field_types item=curr_group_info name=group}
      {assign var=group_info value=$curr_group_info.group}
      {assign var=field_types value=$curr_group_info.field_types}

      <div class="sortable_group">
        <div class="sortable_group_header">
          <div class="sort"></div>
          <label>{$LANG.phrase_group_name}</label>
          <input type="text" name="group_name_{$group_info.group_id}" class="group_name" value="{eval var=$group_info.group_name}" />
          <div class="delete_group"></div>
          <input type="hidden" class="group_order" value="{$group_info.group_id}" />
          <div class="clear"></div>
        </div>
        <div class="sortable edit_custom_fields">
          <ul class="header_row">
            <li class="col1">{$LANG.word_order}</li>
            <li class="col2">{$LANG.phrase_field_type}</li>
            <li class="col3">{$L.phrase_compatible_field_sizes}</li>
            <li class="col4">{$L.phrase_num_settings}</li>
            <li class="col5 edit"></li>
            <li class="col6 colN del"></li>
          </ul>
          <div class="clear"></div>
          <ul class="rows connected_sortable{if $field_types|@count > 0} has_rows_onload{/if}">
            <li class="sortable_row empty_group{if $field_types|@count != 0} hidden{/if}"><div class="clear"></div></li>
            {assign var=previous_item value=""}
            {foreach from=$field_types key=k item=i name=row}
              <li class="sortable_row{if $smarty.foreach.row.last} rowN{/if}">
                <div class="row_content">
                  <div class="row_group{if $smarty.foreach.row.last} rowN{/if}">
                    <input type="hidden" class="sr_order" value="{$i.field_type_id}" />
                    <ul>
                      <li class="col1 sort_col">{$i.list_order}</li>
                      <li class="col2">{eval var=$i.field_type_name}</li>
                      <li class="col3">
                        {field_sizes_dropdown name="compatible_field_sizes" field_type_id=$i.field_type_id}
                      </li>
                      <li class="col4">{$i.settings|@count}</li>
                      <li class="col5 edit"><a href="edit.php?field_type_id={$i.field_type_id}"></a></li>
                      <li class="col6 colN {if $i.is_editable == "yes"} del{/if}{if $i.non_editable_info} info{/if}"></li>
                    </ul>
                    <div class="clear"></div>
                  </div>
                </div>
                <div class="clear"></div>
              </li>
            {/foreach}
          </ul>
        </div>
        <div class="clear"></div>
        <div class="sortable_group_footer">
          <a href="#" class="add_field_link">{$L.phrase_add_field_type_rightarrow}</a>
        </div>
      </div>

      <div class="clear"></div>
    {/foreach}
    </div>

    <div class="margin_bottom_large">
      <a href="#" class="add_group_link">{$LANG.phrase_add_new_group_rightarrow}</a>
    </div>

    <div class="margin_bottom_large">
      <input type="submit" name="update" value="{$LANG.word_update|upper}" />
    </div>

  </form>

  <div class="hidden" id="add_field_popup">
    <div class="add_field_error hidden error"></div>
    <table cellspacing="1" cellpadding="3" width="100%">
    <tr>
      <td width="140" valign="top">{$LANG.phrase_field_name}</td>
      <td><input type="text" class="field_type_name" /></td>
    </tr>
    <tr>
      <td valign="top">{$L.phrase_field_type_identifier}</td>
      <td>
        <input type="text" class="field_type_identifier" />
        <div class="hint">
          This should be an alphanumeric string that will be used to programmatically reference your new field type,
          e.g. "my_field_type"
        </div>
      </td>
    </tr>
    <tr>
      <td valign="top">{$L.word_group}</td>
      <td>
        <select class="group_id" id="original_field_group_id">
        {foreach from=$field_type_groups item=group_info}
          <option value="{$group_info.group_id}">{eval var=$group_info.group_name}</option>
        {/foreach}
      </select>
      </td>
    </tr>
    <tr>
      <td valign="top">{$L.phrase_base_field_type_on}</td>
      <td>
        <select class="original_field_type_id">
          <option value="">{$L.phrase_new_field_b}</option>
          {foreach from=$grouped_field_types item=curr_group_info name=group}
            {assign var=field_types value=$curr_group_info.field_types}
             {foreach from=$field_types key=k item=i name=row}
              <option value="{$i.field_type_id}">{eval var=$i.field_type_name}</option>
            {/foreach}
          {/foreach}
        </select>
      </td>
    </tr>
    </table>
  </div>

  <div class="hidden add_group_popup" id="add_group_popup">
    <input type="hidden" class="add_group_popup_title" value="{$L.phrase_create_new_custom_field_group}" />
    <input type="hidden" class="sortable__add_group_handler" value="cf_ns.create_new_group" />
    <div class="add_field_error hidden error"></div>
    <table cellspacing="1" cellpadding="3" width="100%">
    <tr>
      <td width="140">{$LANG.phrase_group_name}</td>
      <td><input type="text" class="new_group_name" /></td>
    </tr>
    </table>
  </div>

  <!-- for the add group functionality -->
  <div id="sortable__new_group_header" class="hidden">
    <ul class="header_row">
      <li class="col1">{$LANG.word_order}</li>
      <li class="col2">{$LANG.phrase_field_type}</li>
      <li class="col3">{$L.phrase_compatible_field_sizes}</li>
      <li class="col4">{$L.phrase_num_settings}</li>
      <li class="col5 edit"></li>
      <li class="col6 colN del"></li>
    </ul>
  </div>
  <div id="sortable__new_group_footer" class="hidden">
    <div class="sortable_group_footer">
      <a href="#" class="add_field_link">{$L.phrase_add_field_rightarrow}</a>
    </div>
  </div>

  <div id="delete_group_popup" class="hidden">
    {$LANG.phrase_please_wait}
  </div>

{include file='modules_footer.tpl'}