<template>
  <draggable :list="lists" :options="{group: 'lists'}" class="board dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>
  </draggable>
</template>

<script>

import Rails from '@rails/ujs';
import draggable from 'vuedraggable';
import list from 'components/list';

export default {
  components: { draggable, list },
  props: ["original_lists"],
  data: function() {
    return {
      lists: this.original_lists,
    }
  },
  methods: {
    listMoved: function(event) {
      var data = new FormData
      data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        beforeSend: () => true,
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },
  }
}
</script>

<style scoped>
.board {
  white-space: nowrap;
  overflow-x: auto;
}

.container {
  margin-top: 20px;
}

.btn-secondary {
  background-color: #FFB2B2;
  color: #fff;
  border: #969696 solid 1px;
}
</style>
