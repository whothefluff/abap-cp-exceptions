"! <p class="shorttext synchronized" lang="EN">Integration Testing</p>
"! @testing ZCX_CP_NO_CHECK
"! @testing ZCX_CP_DYNAMIC_CHECK
"! @testing ZCX_CP_STATIC_CHECK
"! @testing ZCL_CP_EXCEPTION_READER
class zcl_cp_exception_it definition
                          public
                          final
                          create private
                          for testing
                          duration short
                          risk level harmless.

  public section.

    methods no_check_exc_t100_text for testing.

    methods no_check_exc_t100_dyn_text for testing.

    methods dyn_check_exc_t100_text for testing.

    methods dyn_check_exc_t100_dyn_text for testing.

    methods static_check_exc_t100_text for testing.

    methods static_check_exc_t100_dyn_text for testing.

    methods reader_uses_index for testing.

    methods reader_uses_depth for testing.

  protected section.

endclass.
class zcl_cp_exception_it implementation.

  method no_check_exc_t100_text.

    "arrange
    try.

      raise exception type cx_abap_auth_check_exception exporting textid = cx_abap_auth_check_exception=>unsupported_value_range
                                                                  message_prefix = `pre`.

    catch cx_abap_auth_check_exception into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_no_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).

  endmethod.
  method no_check_exc_t100_dyn_text.

    "arrange
    try.

      raise exception type cx_abap_api_state message e000(ZCPEXC) with 1 2 3 4.

    catch cx_abap_api_state into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_no_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).

  endmethod.
  method dyn_check_exc_t100_text.

    "arrange
    try.

      raise exception type cx_abap_auth_check_exception exporting textid = cx_abap_auth_check_exception=>unsupported_value_range
                                                                  message_prefix = `pre`.

    catch cx_abap_auth_check_exception into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_dynamic_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).

  endmethod.
  method dyn_check_exc_t100_dyn_text.

    "arrange
    try.

      raise exception type cx_abap_api_state message e000(ZCPEXC) with 1 2 3 4.

    catch cx_abap_api_state into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_dynamic_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).


  endmethod.
  method static_check_exc_t100_text.

    "arrange
    try.

      raise exception type cx_abap_auth_check_exception exporting textid = cx_abap_auth_check_exception=>unsupported_value_range
                                                                  message_prefix = `pre`.

    catch cx_abap_auth_check_exception into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_dynamic_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).

  endmethod.
  method static_check_exc_t100_dyn_text.

    "arrange
    try.

      raise exception type cx_abap_api_state message e000(ZCPEXC) with 1 2 3 4.

    catch cx_abap_api_state into final(t100_msg) ##NO_HANDLER.

    endtry.

    "act
    final(e) = new zcx_cp_dynamic_check( t100_msg ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t100_msg->get_text( )
                                        act = e->text( ) ).


  endmethod.
  method reader_uses_index.

    "arrange
    final(cause) = new zcx_static_check( ).

    final(e) = new zcx_no_check( i_previous = cause ).

    final(reader) = new zcl_cp_exception_reader( e ).

    "act & assert
    cl_abap_unit_assert=>assert_true( xsdbool( reader->first( )-exc eq e
                                               and reader->last( )-exc eq cause ) ).

  endmethod.
  method reader_uses_depth.

    "arrange
    final(cause) = new zcx_static_check( ).

    final(e) = new zcx_no_check( i_previous = cause ).

    final(reader) = new zcl_cp_exception_reader( e ).

    "act & assert
    cl_abap_unit_assert=>assert_true( xsdbool( reader->deepest( )-exc eq e
                                               and reader->shallowest( )-exc eq cause ) ).

  endmethod.

endclass.
