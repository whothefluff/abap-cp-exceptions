*"* use this source file for your ABAP unit test classes

class _reader_stub definition ##CLASS_FINAL
                   create public
                   inheriting from zcl_cp_exception_reader.

  public section.

    methods constructor
              importing
                i_chain type zcl_cp_exception_reader=>t_chain optional
                i_depth type i optional
                i_size type i optional.

    methods depth redefinition.

    methods size redefinition.

  protected section.

    data _depth type i.

    data _size type i.

endclass.
class _reader_stub implementation.

  method constructor.

    super->constructor( value #( ) ).

    chain = cond #( when i_chain is supplied
                    then i_chain
                    else chain ).

    _depth = i_depth.

    _size = i_size.

  endmethod.
  method depth.

    r_val = cond #( when _depth is not initial
                    then _depth
                    else super->depth( ) ).

  endmethod.
  method size.

    r_val = cond #( when _size is not initial
                    then _size
                    else super->size( ) ).

  endmethod.

endclass.

"! <p class="shorttext synchronized" lang="EN">Tests</p>
class _ definition
        final
        for testing
        duration short
        risk level harmless.

  private section.

    "! <p class="shorttext synchronized" lang="EN">Constructor creates initial ITAB for null exceptions</p>
    methods const_creates_ini_tab_4_null_e for testing.

    "! <p class="shorttext synchronized" lang="EN">Constructor creates 1-entry ITAB for no-cause exception</p>
    methods const_creates_1e_tab_4_no_c_e for testing.

    "! <p class="shorttext synchronized" lang="EN">Constructor creates 2-entry ITAB for caused exception</p>
    methods const_creates_2e_tab_4_c_e for testing.

    "! <p class="shorttext synchronized" lang="EN">Constructor creates n-entry ITAB for caused exception</p>
    methods const_creates_ne_tab_4_c_e for testing.

    "! <p class="shorttext synchronized" lang="EN">Depth returns max causal depth</p>
    methods depth_rets_cause_depth for testing.

    "! <p class="shorttext synchronized" lang="EN">Deepest returns entry with depth( ) value</p>
    methods deepest_rets_depth_entry for testing.

    "! <p class="shorttext synchronized" lang="EN">Deepest returns empty instead of throwing error</p>
    methods deepest_rets_empty for testing.

    "! <p class="shorttext synchronized" lang="EN">First returns entry with index 1</p>
    methods first_rets_entry_with_index_1 for testing.

    "! <p class="shorttext synchronized" lang="EN">First returns empty instead of throwing error</p>
    methods first_rets_empty for testing.

    "! <p class="shorttext synchronized" lang="EN">HasCause returns true if size is greater than 1</p>
    methods has_cause_rets_true_if_size_g1 for testing.

    "! <p class="shorttext synchronized" lang="EN">HasCause returns false if size is 0 or 1</p>
    methods has_cause_rets_fals_if_size_l2 for testing.

    "! <p class="shorttext synchronized" lang="EN">Last returns entry with index size( )</p>
    methods last_rets_size_entry for testing.

    "! <p class="shorttext synchronized" lang="EN">Last returns empty instead of throwing error</p>
    methods last_rets_empty for testing.

    "! <p class="shorttext synchronized" lang="EN">Reversed returns a new reader with the opposite order</p>
    "! Case A.) A reader for a natural ordering of chain causes returns the opposite ordering
    methods reversed_rets_opposite_order_a for testing.

    "! <p class="shorttext synchronized" lang="EN">Reversed returns a new reader with the opposite order</p>
    "! Case B.) A reader for a random ordering of chain causes returns the opposite ordering
    methods reversed_rets_opposite_order_b for testing.

    "! <p class="shorttext synchronized" lang="EN">Reversed returns a new reader with the opposite order</p>
    "! Case C.) A reader for an empty chain returns empty instead of throwing error
    methods reversed_rets_opposite_order_c for testing.

    "! <p class="shorttext synchronized" lang="EN">Shallowest returns entry with lowest depth value</p>
    methods shal_rets_lowest_depth for testing.

    "! <p class="shorttext synchronized" lang="EN">Shallowest returns empty instead of throwing error</p>
    methods shal_rets_empty for testing.

    "! <p class="shorttext synchronized" lang="EN">Size returns number of entries</p>
    methods size_rets_no_of_entries for testing.

endclass.
class _ implementation.

  method const_creates_ini_tab_4_null_e.

    "act
    final(reader) = new zcl_cp_exception_reader( value #( ) ).

    "assert
    cl_abap_unit_assert=>assert_initial( reader->chain ).

  endmethod.
  method const_creates_1e_tab_4_no_c_e.

    "arrange
    final(e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    "act
    final(reader) = new zcl_cp_exception_reader( e ).

    "assert
    cl_abap_unit_assert=>assert_equals( exp = value zcl_cp_exception_reader=>t_chain( ( depth = 1
                                                                                        exc = e ) )
                                        act = reader->chain ).

  endmethod.
  method const_creates_2e_tab_4_c_e.

    "arrange
    final(cause) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e) = new cx_sy_itab_line_not_found( previous = cause ).

    "act
    final(reader) = new zcl_cp_exception_reader( e ).

    "assert
    cl_abap_unit_assert=>assert_equals( exp = value zcl_cp_exception_reader=>t_chain( ( depth = 2
                                                                                        exc = e )
                                                                                      ( depth = 1
                                                                                        exc = cause ) )
                                        act = reader->chain ).

  endmethod.
  method const_creates_ne_tab_4_c_e.

    "arrange
    final(integer) = cl_abap_random_int=>create( seed = conv #( cl_abap_context_info=>get_system_time( ) )
                                                 min = 3
                                                 max = 100 )->get_next( ).

    final(original_cause) = new cx_sy_itab_error( ).

    data(e) = original_cause.

    do integer times.

      e = new cx_sy_itab_line_not_found( previous = e ).

    enddo.

    "act
    final(reader) = new zcl_cp_exception_reader( e ).

    "assert
    cl_abap_unit_assert=>assert_true( act = xsdbool( lines( reader->chain ) eq integer + 1 )
                                      quit = if_abap_unit_constant=>quit-no ).

    cl_abap_unit_assert=>assert_true( act = xsdbool( reader->chain[ 1 ] = value zcl_cp_exception_reader=>t_chain_entry( depth = integer + 1
                                                                                                                        exc = e ) )
                                      quit = if_abap_unit_constant=>quit-no ).

    cl_abap_unit_assert=>assert_true( act = xsdbool( reader->chain[ integer + 1 ] = value zcl_cp_exception_reader=>t_chain_entry( depth = 1
                                                                                                                                  exc = original_cause ) )
                                      quit = if_abap_unit_constant=>quit-no ).

  endmethod.
  method depth_rets_cause_depth.

    "arrange
    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = 1 )
                                                           ( depth = 11 ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = 11
                                        act = reader->depth( ) ).

  endmethod.
  method deepest_rets_depth_entry.

    "arrange
    final(some_e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(other_e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = 1
                                                             exc = some_e )
                                                           ( depth = 2
                                                             exc = other_e ) ).

    final(reader) = new _reader_stub( i_chain = chain
                                      i_depth = 1 ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_e
                                        act = reader->deepest( )-exc ).

  endmethod.
  method deepest_rets_empty.

    "arrange
    final(reader) = new _reader_stub( i_chain = value #( )
                                      i_depth = 1 ).

    "act & assert
    cl_abap_unit_assert=>assert_initial( reader->deepest( ) ).

  endmethod.
  method first_rets_entry_with_index_1.

    "arrange
    final(e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( exc = e
                                                             depth = -5 )
                                                           ( depth = 20 )
                                                           ( depth = 30 )
                                                           ( depth = 40 )
                                                           ( depth = -7 ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = reader->chain[ 1 ]-exc
                                        act = reader->first( )-exc ).

  endmethod.
  method first_rets_empty.

    "arrange
    final(reader) = new _reader_stub( i_chain = value #( ) ).

    "act & assert
    cl_abap_unit_assert=>assert_initial( reader->first( ) ).

  endmethod.
  method has_cause_rets_true_if_size_g1.

    "arrange
    final(reader) = new _reader_stub( i_size = 2 ).

    "act & assert
    cl_abap_unit_assert=>assert_true( reader->has_cause( ) ).

  endmethod.
  method has_cause_rets_fals_if_size_l2.

    "arrange
    final(reader) = new _reader_stub( i_size = 1 ).

    "act & assert
    cl_abap_unit_assert=>assert_false( reader->has_cause( ) ).

  endmethod.
  method last_rets_size_entry.

    "arrange
    final(e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = -2 )
                                                           ( depth = -30 )
                                                           ( depth = 50 )
                                                           ( depth = 9 )
                                                           ( exc = e
                                                             depth = 0 ) ).

    final(reader) = new _reader_stub( i_chain = chain
                                      i_size = 3 ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = reader->chain[ 3 ]-exc
                                        act = reader->last( )-exc ).

  endmethod.
  method last_rets_empty.

    "arrange
    final(reader) = new _reader_stub( i_chain = value #( ) ).

    "act & assert
    cl_abap_unit_assert=>assert_initial( reader->last( ) ).

  endmethod.
  method reversed_rets_opposite_order_a.

    "arrange
    final(e1) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e2) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e3) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e4) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e5) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = 5
                                                             exc = e1 )
                                                           ( depth = 4
                                                             exc = e2 )
                                                           ( depth = 3
                                                             exc = e3 )
                                                           ( depth = 2
                                                             exc = e4 )
                                                           ( depth = 1
                                                             exc = e5 ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value zcl_cp_exception_reader=>t_chain( ( depth = 1
                                                                                        exc = e5 )
                                                                                      ( depth = 2
                                                                                        exc = e4 )
                                                                                      ( depth = 3
                                                                                        exc = e3 )
                                                                                      ( depth = 4
                                                                                        exc = e2 )
                                                                                      ( depth = 5
                                                                                        exc = e1 ) )
                                        act = reader->reversed( )->chain ).

  endmethod.
  method reversed_rets_opposite_order_b.

    "arrange
    final(e1) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e2) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e3) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e4) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(e5) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = 2
                                                             exc = e2 )
                                                           ( depth = 1
                                                             exc = e1 )
                                                           ( depth = 4
                                                             exc = e4 )
                                                           ( depth = 3
                                                             exc = e3 )
                                                           ( depth = 5
                                                             exc = e5 ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value zcl_cp_exception_reader=>t_chain( ( depth = 5
                                                                                        exc = e5 )
                                                                                      ( depth = 3
                                                                                        exc = e3 )
                                                                                      ( depth = 4
                                                                                        exc = e4 )
                                                                                      ( depth = 1
                                                                                        exc = e1 )
                                                                                      ( depth = 2
                                                                                        exc = e2 ) )
                                        act = reader->reversed( )->chain ).

  endmethod.
  method reversed_rets_opposite_order_c.

    "arrange
    final(reader) = new _reader_stub( i_chain = value #( ) ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = value zcl_cp_exception_reader=>t_chain( )
                                        act = reader->reversed( )->chain ).

  endmethod.
  method shal_rets_lowest_depth.

    "arrange
    final(some_e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(other_e) = cast cx_root( cl_abap_testdouble=>create( 'CX_NO_CHECK' ) ).

    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = 1
                                                             exc = some_e )
                                                           ( depth = 11
                                                             exc = other_e ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = some_e
                                        act = reader->shallowest( )-exc ).

  endmethod.
  method shal_rets_empty.

    "arrange
    final(reader) = new _reader_stub( i_chain = value #( )
                                      i_depth = 1 ).

    "act & assert
    cl_abap_unit_assert=>assert_initial( reader->shallowest( ) ).

  endmethod.
  method size_rets_no_of_entries.

    "arrange
    final(chain) = value zcl_cp_exception_reader=>t_chain( ( depth = -7 )
                                                           ( depth = 20 )
                                                           ( depth = 30 )
                                                           ( depth = 40 )
                                                           ( depth = -5 ) ).

    final(reader) = new _reader_stub( i_chain = chain ).

    "act & assert
    cl_abap_unit_assert=>assert_equals( exp = lines( chain )
                                        act = reader->size( ) ).

  endmethod.

endclass.
