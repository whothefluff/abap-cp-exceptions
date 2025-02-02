*"* use this source file for your ABAP unit test classes
class _t100_dyn_msg_stub definition ##CLASS_FINAL
                         create public
                         for testing.

  public section.

    interfaces: if_t100_dyn_msg partially implemented.

    methods constructor
              importing
                i_key type symsg.

  protected section.

endclass.
class _t100_dyn_msg_stub implementation.

  method constructor.

    xco_cp=>message( i_key )->write_to_t100_dyn_msg( me ).

  endmethod.

endclass.
class _ definition
        final
        for testing
        duration short
        risk level harmless.

  private section.

    methods msg_vars_for_empty for testing.

    methods msg_vars_for_t100 for testing.

    methods msg_vars_for_t100_dyn for testing.

    methods constr_calls_set_and_use_xco for testing.

    methods constructor_fills_stack for testing.

    methods xco_get_messages_delegates for testing.

    methods xco_get_short_text_delegates for testing.

    methods xco_get_text_delegates for testing.

    methods xco_get_type_delegates for testing.

    methods xco_overwrite_delegates for testing.

    methods xco_place_string_delegates for testing.

    methods xco_write_to_t100dyn_delegates for testing.

    methods stack_trace_returns_attribute for testing.

    methods texts_returns_same_as_msg_stmt for testing.

endclass.

class zcx_cp_no_check definition local friends _.

class _ implementation.

  method msg_vars_for_empty.

    "arrange
    final(e) = new zcx_cp_no_check( ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value symsg( msgid = 'SY'
                                                           msgno = 530
                                                           msgty = 'E' )
                                        act = e->_msg_vars( value #( ) ) ).

  endmethod.
  method msg_vars_for_t100.

    "arrange
    try.

      raise exception type cx_abap_auth_check_exception exporting textid = cx_abap_auth_check_exception=>missing_authorization.

    catch cx_abap_auth_check_exception into final(m) ##NO_HANDLER.

    endtry.

    final(e) = new zcx_cp_no_check( ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value symsg( msgid = cx_abap_auth_check_exception=>missing_authorization-msgid
                                                           msgno = cx_abap_auth_check_exception=>missing_authorization-msgno
                                                           msgty = 'E' )
                                        act = e->_msg_vars( m ) ).

  endmethod.
  method msg_vars_for_t100_dyn.

    "arrange
    final(m) = new _t100_dyn_msg_stub( value #( msgid = 'QWE'
                                                msgv3 = 5
                                                msgty = 'S' ) ).

    final(e) = new zcx_cp_no_check( ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value symsg( msgid = m->if_t100_message~t100key-msgid
                                                           msgno = m->if_t100_message~t100key-msgno
                                                           msgty = 'S'
                                                           msgv3 = m->if_t100_dyn_msg~msgv3 )
                                        act = e->_msg_vars( m ) ).

  endmethod.
  method constr_calls_set_and_use_xco.

    "arrange
    final(e) = new zcx_cp_no_check( ).

    final(vars) = value symsg( msgid = 10 ).

    "act
    e->_set_and_use_xco( vars ).

    "assert
    cl_abap_unit_assert=>assert_equals( exp = vars
                                        act = e->_xco_message->value ).

  endmethod.
  method constructor_fills_stack.

    "act & assert
    cl_abap_unit_assert=>assert_bound( new zcx_cp_no_check( )->_stack_trace ).

  endmethod.
  method xco_get_messages_delegates.

    "arrange
    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    final(some_messages) = value sxco_t_messages( ( xco_stub ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->returning( some_messages )->and_expect( )->is_called_once( ).

    xco_stub->if_xco_news~get_messages( ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_messages
                                        act = cast if_xco_news( e )->get_messages( ) ).

  endmethod.
  method xco_get_short_text_delegates.

    "arrange
    final(some_short_text) = cast if_xco_message_short_text( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE_SHORT_TEXT' ) ).

    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->returning( some_short_text )->and_expect( )->is_called_once( ).

    xco_stub->get_short_text( ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_short_text
                                        act = cast if_xco_message( e )->get_short_text( ) ).

  endmethod.
  method xco_get_text_delegates.

    "arrange
    final(some_text) = `ads asdfkajñklñ jñkljaj`.

    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->returning( some_text )->and_expect( )->is_called_once( ).

    xco_stub->get_text( ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_text
                                        act = cast if_xco_message( e )->get_text( ) ).

  endmethod.
  method xco_get_type_delegates.

    "arrange
    final(some_type) = xco_cp_message=>type->for( 'S' ).

    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->returning( some_type )->and_expect( )->is_called_once( ).

    xco_stub->get_type( ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_type
                                        act = cast if_xco_message( e )->get_type( ) ).

  endmethod.
  method xco_overwrite_delegates.

    "arrange
    final(some_ovrwrt_msg) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->ignore_all_parameters( )->returning( some_ovrwrt_msg )->and_expect( )->is_called_once( ).

    xco_stub->overwrite( ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_ovrwrt_msg
                                        act = cast if_xco_message( e )->overwrite( ) ).

  endmethod.
  method xco_place_string_delegates.

    "arrange
    final(some_string) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->ignore_all_parameters( )->returning( some_string )->and_expect( )->is_called_once( ).

    xco_stub->place_string( `` ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_string
                                        act = cast if_xco_message( e )->place_string( `` ) ).

  endmethod.
  method xco_write_to_t100dyn_delegates.

    "arrange
    final(xco_stub) = cast if_xco_message( cl_abap_testdouble=>create( 'IF_XCO_MESSAGE' ) ).

    cl_abap_testdouble=>configure_call( xco_stub )->and_expect( )->is_called_once( ).

    final(m) = new zcx_cp_no_check( ).

    xco_stub->write_to_t100_dyn_msg( m ).

    final(e) = new zcx_cp_no_check( ).

    e->_xco_message = xco_stub.

    "act
    cast if_xco_message( e )->write_to_t100_dyn_msg( m ).

    "assert
    cl_abap_testdouble=>verify_expectations( xco_stub ).

  endmethod.
  method stack_trace_returns_attribute.

    "arrange
    final(some_stack) = cast if_xco_cp_call_stack( cl_abap_testdouble=>create( 'IF_XCO_CP_CALL_STACK' ) ).

    final(e) = new zcx_cp_no_check( ).

    e->_stack_trace = some_stack.

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_stack
                                        act = e->stack_trace( ) ).

  endmethod.
  method texts_returns_same_as_msg_stmt.

    "arrange
    final(var1) = 'ex1'.

    final(var3) = 'ex2'.

    message e000(ZCPEXC) with var1 '' var3 into final(t).

    final(e) = new zcx_cp_no_check( ).

    xco_cp=>message( value #( msgid = 'ZCPEXC'
                              msgno = 000
                              msgv1 = var1
                              msgv3 = var3 ) )->write_to_t100_dyn_msg( e ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = t
                                        act = e->text( ) ).

  endmethod.

endclass.
