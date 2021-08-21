<template>

<div>
  <div @click="editing=true" class="card card-body mb-3 ">
    <a>{{ card.name }}</a>
  </div>

  <div v-if="editing" class="modal-backdrop show"></div>

  <div v-if="editing" @click="closeModal" class="modal show" style="display: block">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Change Name</h5>
        </div>
        <div class="modal-body">
          <input v-model="name" class="form-control"></input>
        </div>
        <div class="modal-footer">
          <button @click="remove" type="button" class="btn btn-primary">Delete Card</button>
          <button @click="save" type="button" class="btn btn-secondary">Save changes</button>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import Rails from '@rails/ujs';

export default {
  props: ['card', 'list'],
  data: function() {
    return {
      editing: false,
      name: this.card.name,
    }
  },
  methods: {
    closeModal: function (event) {
      if (event.target.classList.contains("modal")) {
        this.editing = false
      }
    },

    save: function() {
      var data = new FormData
      data.append("card[name]", this.name)

      Rails.ajax({
        url: `/cards/${this.card.id}`,
        type: "PATCH",
        data: data,
        dataType: "json",
        succes: (data) => {
          const list_index = window.store.lists.findIndex((item) => item.id === this.list.id)
          const card_index = window.store.lists[list_index].cards.findIndex((item) => item.id === this.card.id)
          window.store.lists[list_index].cards.splice(card_index, 1, data)
        }
      })
    },

    remove: function() {
      Rails.ajax({
        url: `/cards/${this.card.id}`,
        type: "DELETE",
        success: function() {
          this.editing = false
        }
      })
    },
  }

}
</script>

<style scoped>
.card {
  border: 1px solid #bebebe;
  font-weight: normal;
  padding: 10px 10px;
}

.btn-secondary {
  background-color: #bc3a3a;
  color: #fafafa;
  font-weight: 600;
  border: none;
}

.btn-secondary:hover {
  background-color: #A93434;
  border: none;
}

.btn-primary {
  background-color: #fff;
  color: #bc3a3a;
  font-weight: 600;
  border: none;
}

.btn-primary:hover {
  background-color: #fff;
  color: #bc3a3a;
  font-weight: 600;
  border: none;
}

.modal-content {
  background-color: #fafafa;
}
</style>
