"! <p class="shorttext synchronized" lang="EN">Exception Reader</p>
class zcl_cp_exception_reader definition
                              public
                              create public.

  public section.

    types:
           "! <p class="shorttext synchronized" lang="EN"></p>
           "! DEPTH is stable and represents the order of causality
           "! <br/><em>1</em> is the original cause and <em>lines</em> is the last wrapping exception
           begin of t_chain_entry,
             depth type i,
             exc type ref to cx_root,
           end of t_chain_entry,
           "! <p class="shorttext synchronized" lang="EN"></p>
           t_chain type standard table of zcl_cp_exception_reader=>t_chain_entry with empty key
                                                                                 with unique sorted key by_depth components depth.

    "! <p class="shorttext synchronized" lang="EN">Creates a reader with the filled exception as 1st chain row</p>
    "!
    "! @parameter i_exception | <p class="shorttext synchronized" lang="EN"></p>
    methods constructor
              importing
                i_exception type ref to cx_root.

    "! <p class="shorttext synchronized" lang="EN">Returns the entry with the most depth of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"><em>1</em> for uncaused exceptions. <em>lines</em> otherwise</p>
    methods deepest
              returning
                value(r_val) type zcl_cp_exception_reader=>t_chain_entry.

    "! <p class="shorttext synchronized" lang="EN">Returns the max depth of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"></p>
    methods depth
              returning
                value(r_val) type i.

    "! <p class="shorttext synchronized" lang="EN">Returns the first entry of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"></p>
    methods first
              returning
                value(r_val) type zcl_cp_exception_reader=>t_chain_entry.

    "! <p class="shorttext synchronized" lang="EN">Returns true when this has an actual chain of exceptions</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN">True for caused exceptions. False otherwise</p>
    methods has_cause
              returning
                value(r_val) type xsdboolean.

    "! <p class="shorttext synchronized" lang="EN">Returns the last entry of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"></p>
    methods last
              returning
                value(r_val) type zcl_cp_exception_reader=>t_chain_entry.

    "! <p class="shorttext synchronized" lang="EN">Creates a new reader with the opposite order to this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"></p>
    methods reversed
              returning
                value(r_val) type ref to zcl_cp_exception_reader.

    "! <p class="shorttext synchronized" lang="EN">Returns the entry with the least depth of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"></p>
    methods shallowest
              returning
                value(r_val) type zcl_cp_exception_reader=>t_chain_entry.

    "! <p class="shorttext synchronized" lang="EN">Returns the number of levels of this object</p>
    "!
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN"><em>1</em> for uncaused exceptions. <em>lines</em> otherwise</p>
    methods size
              returning
                value(r_val) type i.

    "! <p class="shorttext synchronized" lang="EN">Aggregate of an exception and its causes</p>
    data chain type zcl_cp_exception_reader=>t_chain read-only.

  protected section.

endclass.
class zcl_cp_exception_reader implementation.

  method constructor.

    if i_exception is bound.

      chain = value #( ( depth = 1
                         exc = i_exception ) ).

      data(e) = i_exception.

      while e->previous is bound.

        chain = value #( base chain
                         ( depth = sy-index + 1
                           exc = e->previous ) ).

        e = e->previous.

      endwhile.

      chain = value #( let aux = chain in
                       for <c> in aux index into i
                       ( value #( base <c>
                                  depth = lines( aux ) - i + 1 ) ) ).

    endif.

  endmethod.
  method deepest.

    r_val = value #( chain[ key by_depth
                            depth = depth( ) ] optional ).

  endmethod.
  method depth.

    select max( depth )
      from @chain as chain ##ITAB_DB_SELECT
      into @r_val.

  endmethod.
  method first.

    r_val = value #( chain[ 1 ] optional ).

  endmethod.
  method has_cause.

    r_val = xsdbool( size( ) gt 1 ).

  endmethod.
  method last.

    r_val = value #( chain[ size( ) ] optional ).

  endmethod.
  method reversed.

    types indexes type standard table of i with empty key.

    final(indexes) = value indexes( for <c> in chain index into i
                                    ( i ) ).

    select *
      from @indexes as indexes
      order by table_line descending
      into table @final(reversed_indexes).

    final(reader) = new zcl_cp_exception_reader( value #( ) ).

    reader->chain = value #( for <r> in reversed_indexes
                             ( chain[ <r> ] ) ).

    r_val = reader.

  endmethod.
  method shallowest.

    select min( depth )
      from @chain as chain ##ITAB_DB_SELECT
      into @final(min_depth).

    r_val = value #( chain[ key by_depth
                            depth = min_depth ] optional ).

  endmethod.
  method size.

    r_val = lines( chain ).

  endmethod.

endclass.
